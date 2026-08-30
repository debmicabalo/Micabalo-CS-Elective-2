import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const WireframeDashboardApp());
}

class WireframeDashboardApp extends StatelessWidget {
  const WireframeDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Responsive & Adaptive Wireframe',
      home: AdaptiveDashboard(),
    );
  }
}

class AdaptiveDashboard extends StatefulWidget {
  const AdaptiveDashboard({super.key});

  @override
  State<AdaptiveDashboard> createState() => _AdaptiveDashboardState();
}

class _AdaptiveDashboardState extends State<AdaptiveDashboard> {
  int _selectedIndex = 0;

  // Handles state changes for bottom navigation on mobile
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Helper to reliably check if we should show Apple UI
  bool get _isApplePlatform =>
      !kIsWeb && 
      (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS);

  @override
  Widget build(BuildContext context) {
    final isApplePlatform = _isApplePlatform;

    // RESPONSIVE: Evaluate layout constraints at the top level
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

        // ==========================================
        // 1. iOS / macOS NATIVE UI (CUPERTINO)
        // ==========================================
        if (isApplePlatform) {
          if (isMobile) {
            // DISTINCT iOS BOTTOM NAVIGATION
            return CupertinoTabScaffold(
              tabBar: CupertinoTabBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                activeColor: CupertinoColors.activeBlue,
                items: const [
                  BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Home'),
                  BottomNavigationBarItem(icon: Icon(CupertinoIcons.chart_bar), label: 'Stats'),
                  BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings), label: 'Settings'),
                ],
              ),
              tabBuilder: (context, index) {
                return CupertinoTabView(
                  builder: (context) => CupertinoPageScaffold(
                    backgroundColor: CupertinoColors.systemGroupedBackground,
                    navigationBar: const CupertinoNavigationBar(
                      middle: Text('Dashboard (iOS)'),
                    ),
                    child: SafeArea(child: _buildMobileLayout(index, true)),
                  ),
                );
              },
            );
          }
          
          // iOS Tablet/Desktop Layout: No bottom tabs
          return CupertinoPageScaffold(
            backgroundColor: CupertinoColors.systemGroupedBackground,
            navigationBar: const CupertinoNavigationBar(
              middle: Text('Dashboard (macOS/iPadOS)'),
            ),
            child: SafeArea(
              child: isTablet ? _buildTabletLayout(true) : _buildDesktopLayout(true),
            ),
          );
        }

        // ==========================================
        // 2. ANDROID / WEB UI (MATERIAL DESIGN)
        // ==========================================
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: Text(kIsWeb ? 'Dashboard (Web)' : 'Dashboard (Android)'),
            elevation: kIsWeb ? 0 : 2, 
            backgroundColor: Colors.blueGrey.shade800,
            foregroundColor: Colors.white,
          ),
          // DISTINCT ANDROID/MATERIAL 3 BOTTOM NAVIGATION (Pill-shaped indicators)
          bottomNavigationBar: isMobile
              ? NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onItemTapped,
                  indicatorColor: Colors.blue.shade200,
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
                    NavigationDestination(icon: Icon(Icons.analytics_outlined), selectedIcon: Icon(Icons.analytics), label: 'Stats'),
                    NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
                  ],
                )
              : null,
          body: isMobile
              ? _buildMobileLayout(_selectedIndex, false)
              : (isTablet ? _buildTabletLayout(false) : _buildDesktopLayout(false)),
        );
      },
    );
  }

  // --- RESPONSIVE LAYOUTS ---

  Widget _buildMobileLayout(int tabIndex, bool isApple) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Viewing Mobile Tab: $tabIndex',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: List.generate(4, (index) => _WireframeBox(isApple: isApple)),
        ),
        const SizedBox(height: 16),
        _WireframeBox(height: 180, isApple: isApple),
        const SizedBox(height: 16),
        _WireframeBox(height: 180, isApple: isApple),
        const SizedBox(height: 16),
        ...List.generate(5, (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _WireframeBox(
            height: 80, 
            isApple: isApple, 
            child: _AdaptiveActionWidget(index: index, isApple: isApple)
          ),
        )),
      ],
    );
  }

  Widget _buildTabletLayout(bool isApple) {
    return Row(
      children: [
        _buildSidebar(width: 200, isApple: isApple),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
                children: List.generate(4, (index) => _WireframeBox(isApple: isApple)),
              ),
              const SizedBox(height: 24),
              _WireframeBox(height: 250, isApple: isApple),
              const SizedBox(height: 16),
              ...List.generate(5, (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _WireframeBox(
                  height: 80, 
                  isApple: isApple, 
                  child: _AdaptiveActionWidget(index: index, isApple: isApple)
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(bool isApple) {
    return Row(
      children: [
        _buildSidebar(width: 250, isApple: isApple),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(4, (index) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: _WireframeBox(height: 140, isApple: isApple),
                    ),
                  )),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
                            child: _WireframeBox(
                              height: 80, 
                              isApple: isApple,
                              child: Center(child: _AdaptiveActionWidget(index: index, isApple: isApple)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Expanded(flex: 3, child: _WireframeBox(isApple: isApple)),
                            const SizedBox(height: 16),
                            Expanded(flex: 2, child: _WireframeBox(isApple: isApple)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- SIDEBAR COMPONENT ---
  Widget _buildSidebar({required double width, required bool isApple}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: isApple ? CupertinoColors.white : Colors.white,
        border: isApple 
            ? const Border(right: BorderSide(color: CupertinoColors.systemGrey4))
            : Border(right: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 48),
          
          // WIREFRAME IMAGE PLACEHOLDER (Replaced Heart Logo)
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isApple ? CupertinoColors.systemGrey5 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isApple ? CupertinoColors.systemGrey3 : Colors.grey.shade400, 
                  width: 2
                ),
              ),
              child: Icon(
                isApple ? CupertinoIcons.photo : Icons.image_outlined, 
                size: 32, 
                color: Colors.grey.shade600
              ),
            ),
          ),
          
          const SizedBox(height: 48),
          _SidebarItem(icon: isApple ? CupertinoIcons.home : Icons.home, label: 'DASHBOARD'),
          _SidebarItem(icon: isApple ? CupertinoIcons.settings : Icons.settings, label: 'SETTINGS'),
          _SidebarItem(icon: isApple ? CupertinoIcons.info : Icons.info, label: 'ABOUT'),
          const Spacer(),
          _SidebarItem(icon: isApple ? CupertinoIcons.square_arrow_right : Icons.logout, label: 'LOGOUT'),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SidebarItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600),
          const SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}

// --- ADAPTIVE WIREFRAME BOX ---
class _WireframeBox extends StatelessWidget {
  final double? height;
  final bool isApple;
  final Widget? child;

  const _WireframeBox({this.height, required this.isApple, this.child});

  @override
  Widget build(BuildContext context) {
    if (isApple) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: CupertinoColors.systemGrey4, width: 1.0),
        ),
        child: child,
      );
    }

    return SizedBox(
      height: height,
      child: Card(
        elevation: 2,
        shadowColor: Colors.black12,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: child,
      ),
    );
  }
}

/// Distinctly swaps Button Designs
class _AdaptiveActionWidget extends StatelessWidget {
  final int index;
  final bool isApple;

  const _AdaptiveActionWidget({required this.index, required this.isApple});

  @override
  Widget build(BuildContext context) {
    if (isApple) {
      // DISTINCT iOS BUTTON
      return CupertinoButton.filled(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        borderRadius: BorderRadius.circular(20),
        onPressed: () {},
        child: Text('Action $index'),
      );
    }

    // DISTINCT MATERIAL BUTTON
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: Colors.blueGrey.shade800,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text('Action $index'),
    );
  }
}