import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'cart.dart';
import 'products.dart';
import 'screens/home_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ManyokensApp());
}

class ManyokensApp extends StatefulWidget {
  const ManyokensApp({super.key});

  @override
  State<ManyokensApp> createState() =>
      _ManyokensAppState();
}

class _ManyokensAppState extends State<ManyokensApp> {
  ThemeMode _themeMode = ThemeMode.light;

  final CartController _cart = CartController();

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light
              ? ThemeMode.dark
              : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        _themeMode == ThemeMode.dark;

    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return HomeScreen(
              isDarkMode: isDarkMode,
              onToggleTheme: _toggleTheme,
              cart: _cart,
            );
          },
        ),

        GoRoute(
          path: '/details',
          builder: (context, state) {
            final Product? product =
                state.extra as Product?;

            if (product == null) {
              return const _InvalidProductPage();
            }

            return ProductDetailsScreen(
              product: product,
              cart: _cart,
            );
          },
        ),

        GoRoute(
          path: '/cart',
          builder: (context, state) {
            return CartScreen(
              cart: _cart,
            );
          },
        ),

        GoRoute(
          path: '/checkout',
          redirect: (context, state) {
            if (_cart.isEmpty) {
              return '/cart';
            }

            return null;
          },
          builder: (context, state) {
            return CheckoutScreen(
              cart: _cart,
            );
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'manyokens',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      routerConfig: router,
    );
  }
}

class _InvalidProductPage
    extends StatelessWidget {
  const _InvalidProductPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PRODUCT DETAILS'),
      ),
      body: Center(
        child: FilledButton(
          onPressed: () {
            context.go('/');
          },
          child: const Text('BACK TO SHOP'),
        ),
      ),
    );
  }
}