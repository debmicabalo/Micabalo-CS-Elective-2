import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/state_providers.dart';
import '../providers/theme_provider.dart'; // Make sure this is here
import '../widgets/product_card.dart';
import '../widgets/price_slider_filter.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsyncValue = ref.watch(productsProvider);
    final filterState = ref.watch(filterProvider);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Store'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.push('/cart'),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: PriceSliderFilter(),
          ),
          Expanded(
            child: productsAsyncValue.when(
              data: (products) => LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive Grid layout
                  int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                  
                  if (products.isEmpty) {
                    return const Center(child: Text('No products found in this price range.'));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) => ProductCard(product: products[index]),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
          
          // Pagination Controls
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: filterState.pageIndex > 0 
                      ? () => ref.read(filterProvider.notifier).prevPage() 
                      : null,
                ),
                Text('Page ${filterState.pageIndex + 1}'),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  // Assume we disable "Next" if less than 6 items are returned on the current page
                  onPressed: productsAsyncValue.value?.length == 6
                      ? () => ref.read(filterProvider.notifier).nextPage()
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}