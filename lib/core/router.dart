import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/product_details_screen.dart';
import '../screens/auth_screen.dart';
import '../models/product.dart';

final appRouter = GoRouter(
  // Set Auth as the first screen the user sees
  initialLocation: '/auth',
  routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/product',
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetailsScreen(product: product);
      },
    ),
  ],
);