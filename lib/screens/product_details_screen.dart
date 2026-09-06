import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../cart.dart';
import '../products.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  final CartController cart;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PRODUCT DETAILS'),
        actions: [
          AnimatedBuilder(
            animation: cart,
            builder: (context, child) {
              return IconButton(
                onPressed: () {
                  context.push('/cart');
                },
                icon: Badge(
                  label: Text('${cart.itemCount}'),
                  isLabelVisible: cart.itemCount > 0,
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide =
              constraints.maxWidth >= 700;

          return SingleChildScrollView(
            padding: EdgeInsets.all(
              isWide ? 32 : 20,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1000,
                ),
                child: isWide
                    ? _WideProductLayout(
                        product: product,
                        cart: cart,
                        theme: theme,
                        colors: colors,
                      )
                    : _MobileProductLayout(
                        product: product,
                        cart: cart,
                        theme: theme,
                        colors: colors,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MobileProductLayout extends StatelessWidget {
  final Product product;
  final CartController cart;
  final ThemeData theme;
  final ColorScheme colors;

  const _MobileProductLayout({
    required this.product,
    required this.cart,
    required this.theme,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _ProductImage(product: product),
        const SizedBox(height: 24),
        _ProductInformation(
          product: product,
          cart: cart,
          theme: theme,
          colors: colors,
        ),
      ],
    );
  }
}

class _WideProductLayout extends StatelessWidget {
  final Product product;
  final CartController cart;
  final ThemeData theme;
  final ColorScheme colors;

  const _WideProductLayout({
    required this.product,
    required this.cart,
    required this.theme,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: _ProductImage(
            product: product,
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 5,
          child: _ProductInformation(
            product: product,
            cart: cart,
            theme: theme,
            colors: colors,
          ),
        ),
      ],
    );
  }
}

class _ProductImage extends StatelessWidget {
  final Product product;

  const _ProductImage({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors =
        Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          color:
              colors.surfaceContainerHighest,
          padding: const EdgeInsets.all(24),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.contain,
            errorBuilder:
                (context, error, stackTrace) {
              return Icon(
                Icons.image_not_supported_outlined,
                size: 80,
                color: colors.onSurfaceVariant,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProductInformation extends StatelessWidget {
  final Product product;
  final CartController cart;
  final ThemeData theme;
  final ColorScheme colors;

  const _ProductInformation({
    required this.product,
    required this.cart,
    required this.theme,
    required this.colors,
  });

  void _addToCart(BuildContext context) {
    cart.add(product);

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          product.brand.toUpperCase(),
          style: theme.textTheme.labelLarge?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.name,
          style: theme.textTheme.headlineMedium
              ?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '₱${product.price.toStringAsFixed(0)}',
          style: theme.textTheme.headlineSmall
              ?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Product Details',
          style: theme.textTheme.titleLarge
              ?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Experience premium performance and modern '
          'design with the ${product.name}. This '
          'smartphone combines powerful hardware, '
          'a high-quality display, and a sleek design '
          'for everyday use.',
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: FilledButton.icon(
            onPressed: () {
              _addToCart(context);
            },
            icon: const Icon(
              Icons.shopping_cart_outlined,
            ),
            label: const Text('ADD TO CART'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton(
            onPressed: () {
              context.push('/cart');
            },
            child: const Text('VIEW CART'),
          ),
        ),
      ],
    );
  }
}