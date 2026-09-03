import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/product_details_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ManyokensApp());
}

class ManyokensApp extends StatefulWidget {
  const ManyokensApp({super.key});

  @override
  State<ManyokensApp> createState() => _ManyokensAppState();
}

class _ManyokensAppState extends State<ManyokensApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = _themeMode == ThemeMode.dark;

    final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return HomeScreen(
              isDarkMode: isDarkMode,
              onToggleTheme: _toggleTheme,
            );
          },
        ),
        GoRoute(
          path: '/details',
          builder: (context, state) {
            return const ProductDetailsScreen();
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