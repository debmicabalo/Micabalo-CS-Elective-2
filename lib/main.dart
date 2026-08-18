import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const FruitApp());

// --- 1. Router Configuration ---
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const FruitListScreen();
      },
      // Nested detail route
      routes: <RouteBase>[
        GoRoute(
          path: 'fruit/:name', 
          builder: (BuildContext context, GoRouterState state) {
            final String fruitName = state.pathParameters['name']!;
            return FruitDetailScreen(fruitName: fruitName);
          },
        ),
      ],
    ),
  ],
);

// --- 2. Main App Widget ---
class FruitApp extends StatelessWidget {
  const FruitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fruit Router Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true, // Centering the AppBar Title
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}

// --- 3. Data Model ---
class Fruit {
  final String name;
  final String emoji;
  final List<Color> gradientColors;

  const Fruit(this.name, this.emoji, this.gradientColors);
}

// Expanded catalog of fruits with custom gradients
final List<Fruit> fruitCatalog = [
  const Fruit('Apple', '🍎', [Color(0xFFFF416C), Color(0xFFFF4B2B)]),
  const Fruit('Banana', '🍌', [Color(0xFFF2C94C), Color(0xFFF2994A)]),
  const Fruit('Watermelon', '🍉', [Color(0xFF56AB2F), Color(0xFFA8E063)]),
  const Fruit('Grapes', '🍇', [Color(0xFF654EA3), Color(0xFFEA8D8D)]),
  const Fruit('Orange', '🍊', [Color(0xFFFF8008), Color(0xFFFFC837)]),
  const Fruit('Strawberry', '🍓', [Color(0xFFff0844), Color(0xFFffb199)]),
  const Fruit('Pineapple', '🍍', [Color(0xFFF2C94C), Color(0xFF56AB2F)]),
  const Fruit('Kiwi', '🥝', [Color(0xFF11998e), Color(0xFF38ef7d)]),
  const Fruit('Peach', '🍑', [Color(0xFFff9a44), Color(0xFFfc6076)]),
  const Fruit('Blueberry', '🫐', [Color(0xFF4b6cb7), Color(0xFF182848)]),
];

// --- 4. Screens ---

class FruitListScreen extends StatelessWidget {
  const FruitListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fruit Market'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        physics: const BouncingScrollPhysics(), // Fun, bouncy scrolling effect
        itemCount: fruitCatalog.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final fruit = fruitCatalog[index];
          
          // Beautiful elevated card with a subtle shadow
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: fruit.gradientColors.last.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                splashColor: fruit.gradientColors.first.withOpacity(0.1),
                highlightColor: fruit.gradientColors.first.withOpacity(0.05),
                onTap: () {
                  // Navigate to nested route
                  context.go('/fruit/${fruit.name.toLowerCase()}');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Clickable elements centered
                    children: [
                      Hero(
                        tag: 'emoji_${fruit.name}',
                        child: Text(
                          fruit.emoji, 
                          style: const TextStyle(
                            fontSize: 36, 
                            decoration: TextDecoration.none // Prevent yellow underline in hero transiton
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        fruit.name, 
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F3F5),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded, 
                          size: 16, 
                          color: Colors.black54
                        ),
                      ),
                    ],
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

class FruitDetailScreen extends StatelessWidget {
  final String fruitName;

  const FruitDetailScreen({super.key, required this.fruitName});

  @override
  Widget build(BuildContext context) {
    // Find the corresponding fruit data, default to Apple if something weird happens
    final fruit = fruitCatalog.firstWhere(
      (f) => f.name.toLowerCase() == fruitName.toLowerCase(),
      orElse: () => fruitCatalog.first,
    );

    return Scaffold(
      extendBodyBehindAppBar: true, // Let the gradient flow behind the AppBar
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white), // White back arrow
        title: Text(
          '${fruitName[0].toUpperCase()}${fruitName.substring(1)} Details',
          style: const TextStyle(color: Colors.white), // White title
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          // Dynamic gradient based on the fruit clicked
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: fruit.gradientColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Glassmorphism-style container for the emoji
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: Hero(
                  tag: 'emoji_${fruit.name}',
                  child: Text(
                    fruit.emoji,
                    style: const TextStyle(
                      fontSize: 120,
                      decoration: TextDecoration.none,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              
              // Styled text overlaying the gradient
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Fresh & Delicious',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You selected a beautiful ${fruit.name}!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}