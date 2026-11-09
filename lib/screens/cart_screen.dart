import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/platform_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Cart is currently empty.'),
            const SizedBox(height: 20),
            PlatformButton(
              label: 'Continue Shopping',
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}