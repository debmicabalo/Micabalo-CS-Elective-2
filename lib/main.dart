import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const NowPlayingScreen(),
    );
  }
}

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  // State variables for interactive controls
  bool _isPlaying = true;
  bool _isFavorite = false;
  bool _isAdded = false;
  bool _isShuffleActive = false;
  int _repeatMode = 0; // 0: Off, 1: Repeat All, 2: Repeat One
  double _currentProgress = 0.44;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFA67C52), // Top lighter brown
              Color(0xFF5A4027), // Mid darker brown
              Color(0xFF1E150D), // Bottom dark brown/black
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false, 
          child: Column(
            children: [
              _buildStatusBar(),
              const SizedBox(height: 10),
              _buildTopIndicator(),
              const SizedBox(height: 24),
              _buildAlbumArt(),
              const SizedBox(height: 32),
              _buildSongInfo(),
              const SizedBox(height: 20),
              _buildProgressBar(),
              const SizedBox(height: 10),
              _buildPlaybackControls(),
              const SizedBox(height: 24),
              _buildBottomActions(),
              const Spacer(),
              _buildLyricsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '16:00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: const [
              Icon(Icons.signal_cellular_alt, color: Colors.white, size: 16),
              SizedBox(width: 6),
              Icon(Icons.wifi, color: Colors.white, size: 16),
              SizedBox(width: 6),
              Icon(Icons.battery_full, color: Colors.white, size: 18),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopIndicator() {
    return GestureDetector(
      onTap: () => _showSnackBar('Minimize Player tapped'),
      child: SizedBox(
        width: 48,
        height: 8,
        child: CustomPaint(
          painter: _WideChevronPainter(),
        ),
      ),
    );
  }

  Widget _buildAlbumArt() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.asset(
            'sawayama.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[800],
              child: const Center(
                child: Icon(Icons.image, size: 50, color: Colors.white54),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSongInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Akasaka Sad',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rina Sawayama',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          _buildHoverIcon(
            icon: _isAdded ? Icons.check_circle : Icons.add_circle_outline,
            onPressed: () {
              setState(() {
                _isAdded = !_isAdded;
              });
              _showSnackBar(_isAdded ? 'Added to library' : 'Removed from library');
            },
            size: 28,
            color: _isAdded ? const Color(0xFF1DB954) : Colors.white,
          ),
          _buildHoverIcon(
            icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              _showSnackBar(_isFavorite ? 'Saved to Liked Songs' : 'Removed from Liked Songs');
            },
            size: 28,
            color: _isFavorite ? const Color(0xFF1DB954) : Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
              thumbColor: Colors.white,
            ),
            child: Slider(
              value: _currentProgress, 
              onChanged: (value) {
                setState(() {
                  _currentProgress = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '1:19',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '-1:39',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaybackControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHoverIcon(
            icon: Icons.shuffle,
            onPressed: () {
              setState(() {
                _isShuffleActive = !_isShuffleActive;
              });
              _showSnackBar(_isShuffleActive ? 'Shuffle enabled' : 'Shuffle disabled');
            },
            size: 28,
            color: _isShuffleActive ? const Color(0xFF1DB954) : Colors.white,
          ),
          _buildHoverIcon(
            icon: Icons.skip_previous,
            onPressed: () => _showSnackBar('Previous track'),
            size: 42,
          ),
          // Play / Pause central button wrapped in our new HoverScale class
          HoverScale(
            scaleFactor: 1.08, // Slightly less scale for the big button
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                color: Colors.black,
                iconSize: 42,
                padding: const EdgeInsets.all(16),
                onPressed: () {
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                },
              ),
            ),
          ),
          _buildHoverIcon(
            icon: Icons.skip_next,
            onPressed: () => _showSnackBar('Next track'),
            size: 42,
          ),
          _buildHoverIcon(
            icon: _repeatMode == 2 ? Icons.repeat_one : Icons.repeat,
            onPressed: () {
              setState(() {
                _repeatMode = (_repeatMode + 1) % 3;
              });
              String modeText = ['Repeat Off', 'Repeat All', 'Repeat One'][_repeatMode];
              _showSnackBar(modeText);
            },
            size: 28,
            color: _repeatMode > 0 ? const Color(0xFF1DB954) : Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => _showSnackBar('Audio output: AirPods Max connected'),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: const [
                      Icon(Icons.bluetooth, color: Color(0xFF1DB954), size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Airpods Max',
                        style: TextStyle(
                          color: Color(0xFF1DB954),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              HoverTextButton(
                icon: Icons.view_headline,
                label: 'SAWAYAMA',
                onPressed: () => _showSnackBar('Opening Album: SAWAYAMA'),
              ),
              const Spacer(),
              _buildHoverIcon(
                icon: Icons.nightlight_round,
                onPressed: () => _showSnackBar('Sleep timer options'),
                size: 22,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 20),
              _buildHoverIcon(
                icon: Icons.ios_share,
                onPressed: () => _showSnackBar('Share options opened'),
                size: 22,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLyricsCard() {
    return HoverScale(
      scaleFactor: 1.02, // Subtle scale for the large card
      child: GestureDetector(
        onTap: () => _showSnackBar('Opening Full Screen Lyrics'),
        child: Container(
          height: 80, 
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 20.0),
          decoration: BoxDecoration(
            color: const Color(0xFFC7A27C), 
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 12.0,
                spreadRadius: 20.0,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  'Lyrics',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.open_in_full,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Simplified helper that just wraps standard IconButtons in our new HoverScale class
  Widget _buildHoverIcon({
    required IconData icon,
    required VoidCallback onPressed,
    double size = 28,
    Color color = Colors.white,
  }) {
    return HoverScale(
      child: IconButton(
        icon: Icon(icon, color: color, size: size),
        onPressed: onPressed,
      ),
    );
  }
}


/// A reusable widget that scales up its child when hovered.
class HoverScale extends StatefulWidget {
  final Widget child;
  final double scaleFactor;

 const HoverScale({
    super.key,
    required this.child,
    this.scaleFactor = 1.2,
  });

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isHovered ? widget.scaleFactor : 1.0,
        duration: const Duration(milliseconds: 200),
        child: widget.child,
      ),
    );
  }
}

/// A reusable text button that adds a background highlight when hovered.
class HoverTextButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

 const HoverTextButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  State<HoverTextButton> createState() => _HoverTextButtonState();
}

class _HoverTextButtonState extends State<HoverTextButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(widget.icon, color: Colors.white.withValues(alpha: 0.7), size: 22),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom Painter to draw the specific "wide ^" shape
class _WideChevronPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height) // Start bottom left
      ..lineTo(size.width / 2, 0) // Peak in top center
      ..lineTo(size.width, size.height); // End bottom right

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}