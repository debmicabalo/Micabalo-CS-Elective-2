import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../cart.dart';
import '../products.dart';

class CheckoutScreen extends StatelessWidget {
  final CartController cart;

  const CheckoutScreen({
    super.key,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    final entries = cart.items.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ORDER CONFIRMATION'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 850,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 70,
                          color: colors.primary,
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'ORDER CONFIRMED',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Thank you for shopping with manyokens!',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'ORDER SUMMARY',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        for (final entry in entries)
                          _CheckoutItem(
                            product: entry.key,
                            quantity: entry.value,
                          ),

                        const Divider(height: 30),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'TOTAL',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              '₱${cart.total.toStringAsFixed(0)}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: colors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () {
                      cart.clear();
                      context.go('/');
                    },
                    child: const Text('BACK TO SHOP'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckoutItem extends StatelessWidget {
  final Product product;
  final int quantity;

  const _CheckoutItem({
    required this.product,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final double subtotal = product.price * quantity;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '₱${product.price.toStringAsFixed(0)} × $quantity',
                ),
              ],
            ),
          ),

          Text(
            '₱${subtotal.toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
