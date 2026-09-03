import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Product {
  final String name;
  final String brand;
  final double price;
  final String imageUrl;

  const Product({
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
  });
}

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  String selectedCategory = 'All';

  final List<String> categories = const [
    'All',
    'Apple',
    'Samsung',
    'Google',
    'Xiaomi',
    'OnePlus',
    'Nothing',
    'ASUS',
    'Sony',
  ];

  final List<Product> products = const [
    Product(
      name: 'iPhone 16 Pro',
      brand: 'Apple',
      price: 69999,
      imageUrl:
          'https://images.unsplash.com/photo-1592286927505-9f6b2d5b6b5d?auto=format&fit=crop&w=800&q=80',
    ),
    Product(
      name: 'Galaxy S25 Ultra',
      brand: 'Samsung',
      price: 84999,
      imageUrl:
          'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?auto=format&fit=crop&w=800&q=80',
    ),
    Product(
      name: 'Pixel 9 Pro',
      brand: 'Google',
      price: 62999,
      imageUrl:
          'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80',
    ),
    Product(
      name: 'Xiaomi 15 Ultra',
      brand: 'Xiaomi',
      price: 57999,
      imageUrl:
          'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    ),
    Product(
      name: 'OnePlus 13',
      brand: 'OnePlus',
      price: 49999,
      imageUrl:
          'https://images.unsplash.com/photo-1556656793-08538906a9f8?auto=format&fit=crop&w=800&q=80',
    ),
    Product(
      name: 'Nothing Phone',
      brand: 'Nothing',
      price: 42999,
      imageUrl:
          'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=800&q=80',
    ),
    Product(
      name: 'ROG Phone 9 Pro',
      brand: 'ASUS',
      price: 59999,
      imageUrl:
      'https://images.unsplash.com/photo-1601784551446-20c9e07cdbdb?auto=format&fit=crop&w=800&q=80',
    ),
    Product(
      name: 'Xperia 1 VI',
      brand: 'Sony',
      price: 69999,
      imageUrl:
      'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80',
    ),
  ];

  List<Product> get filteredProducts {
    if (selectedCategory == 'All') {
      return products;
    }

    return products
        .where((product) => product.brand == selectedCategory)
        .toList();
  }

  void _selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void _scrollToProducts() {
    _scrollController.animateTo(
      520,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'manyokens',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            tooltip: 'Toggle theme',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;

          final int columns = width < 600
              ? 2
              : width < 1000
                  ? 3
                  : 4;

          final double horizontalPadding = width < 600
              ? 16
              : width < 1000
                  ? 24
                  : 32;

          final double spacing = width < 600
              ? 10
              : width < 1000
                  ? 16
                  : 20;

          final double usableWidth =
              width -
              (horizontalPadding * 2) -
              (spacing * (columns - 1));

          final double cardWidth = usableWidth / columns;
          final double cardHeight = cardWidth * 1.08 + 100;

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: HeroBanner(
                  onExplore: _scrollToProducts,
                ),
              ),
              SliverToBoxAdapter(
                child: CategoryBar(
                  categories: categories,
                  selectedCategory: selectedCategory,
                  onCategorySelected: _selectCategory,
                ),
              ),
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: selectedCategory,
                  itemCount: filteredProducts.length,
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  32,
                ),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final Product product = filteredProducts[index];

                      return ProductCard(
                        product: product,
                        onTap: () {
                          context.push('/details');
                        },
                      );
                    },
                    childCount: filteredProducts.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    mainAxisExtent: cardHeight,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class HeroBanner extends StatelessWidget {
  final VoidCallback onExplore;

  const HeroBanner({
    super.key,
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primary = theme.colorScheme.primary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        final double height = width < 360
            ? 390
            : width < 600
                ? 440
                : width < 1000
                    ? 500
                    : 560;

        final double titleSize = width < 360
            ? 42
            : width < 600
                ? 48
                : width < 1000
                    ? 60
                    : 76;

        return Container(
          width: double.infinity,
          height: height,
          color: primary,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primary,
                      Color.lerp(primary, Colors.black, 0.28)!,
                      Colors.black,
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: _HeroGridPainter(
                    color: Colors.white.withOpacity(0.07),
                  ),
                ),
              ),
              Positioned(
                right: -width * 0.08,
                top: -100,
                child: Transform.rotate(
                  angle: -0.22,
                  child: Container(
                    width: width * 0.50,
                    height: height * 1.35,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),
              Positioned(
                right: width * 0.04,
                bottom: -110,
                child: Container(
                  width: width < 600 ? 180 : 280,
                  height: width < 600 ? 180 : 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.10),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: width * 0.08,
                top: height * 0.10,
                child: Container(
                  width: width < 600 ? 150 : 220,
                  height: width < 600 ? 150 : 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.10),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 5,
                child: Container(
                  color: Colors.white.withOpacity(0.35),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: 3,
                child: Container(
                  color: Colors.white.withOpacity(0.20),
                ),
              ),
              if (width >= 600)
                Positioned(
                  right: width * 0.10,
                  bottom: 35,
                  child: const _HeroPhoneGraphic(),
                ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width < 600 ? 22 : 48,
                  vertical: width < 600 ? 32 : 50,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: width < 600 ? width * 0.82 : 650,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MANYOKENS',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.72),
                            fontSize: width < 600 ? 12 : 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3,
                          ),
                        ),
                        SizedBox(height: width < 600 ? 16 : 22),
                        Text(
                          'UPGRADE\nYOUR WORLD.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: titleSize,
                            fontWeight: FontWeight.w900,
                            height: 0.92,
                            letterSpacing: -2.5,
                          ),
                        ),
                        SizedBox(height: width < 600 ? 20 : 26),
                        Text(
                          'Premium smartphones. Powerful technology.\nBuilt for the way you live.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.78),
                            fontSize: width < 600 ? 14 : 17,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: width < 600 ? 26 : 32),
                        GestureDetector(
                          onTap: onExplore,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'EXPLORE COLLECTION',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width < 600 ? 12 : 14,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeroGridPainter extends CustomPainter {
  final Color color;

  const _HeroGridPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const double spacing = 42;

    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HeroGridPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _HeroPhoneGraphic extends StatelessWidget {
  const _HeroPhoneGraphic();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withOpacity(0.28),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            bottom: 10,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.10),
                ),
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          const Positioned(
            top: 18,
            left: 57,
            child: _CameraDot(),
          ),
          Positioned(
            left: 22,
            right: 22,
            bottom: 35,
            child: Container(
              height: 2,
              color: Colors.white.withOpacity(0.15),
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraDot extends StatelessWidget {
  const _CameraDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class CategoryBar extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 72,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 28),
        itemBuilder: (context, index) {
          final String category = categories[index];
          final bool isSelected = category == selectedCategory;

          return GestureDetector(
            onTap: () => onCategorySelected(category),
            behavior: HitTestBehavior.opaque,
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? colors.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected
                        ? colors.onSurface
                        : colors.onSurface.withOpacity(0.55),
                    fontWeight:
                        isSelected ? FontWeight.w800 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final int itemCount;

  const SectionHeader({
    super.key,
    required this.title,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final Color muted =
        Theme.of(context).colorScheme.onSurface.withOpacity(0.55);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              '$itemCount items',
              style: TextStyle(
                color: muted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: colors.surfaceContainerHighest,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.phone_android,
                        size: 52,
                        color: colors.onSurface.withOpacity(0.25),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) {
                      return child;
                    }

                    return const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 13, 14, 4),
              child: Text(
                product.brand.toUpperCase(),
                style: TextStyle(
                  color: colors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.3,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
              child: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Text(
                '₱${product.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}