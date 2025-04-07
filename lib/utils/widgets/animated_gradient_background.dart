import 'package:flutter/material.dart';
import 'package:jejom/utils/theme/app_theme.dart';
import 'dart:math' as math;

/// An animated gradient background that provides subtle motion
/// Can be used as the base layer for screens in both travel and game modes
class AnimatedGradientBackground extends StatefulWidget {
  final Widget? child;
  final bool isGameMode;
  
  const AnimatedGradientBackground({
    super.key,
    this.child,
    this.isGameMode = false,
  });

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Color> _colorList;
  
  final List<Color> _travelColorList = [
    const Color(0xFFE0E6FF), // Light blue
    const Color(0xFFD5E6F3), // Soft blue
    const Color(0xFFE6F3F5), // Light cyan
    const Color(0xFFDCE6F2), // Light sky blue
  ];
  
  final List<Color> _gameColorList = [
    const Color(0xFFEDE5FF), // Light purple
    const Color(0xFFF5E7F5), // Soft pink
    const Color(0xFFE9E5F5), // Light lavender
    const Color(0xFFF2E7F5), // Soft lavender
  ];
  
  @override
  void initState() {
    super.initState();
    
    // Select colors based on mode
    _colorList = widget.isGameMode ? _gameColorList : _travelColorList;
    
    // Initialize animation controller for a slow, subtle animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  void didUpdateWidget(AnimatedGradientBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isGameMode != widget.isGameMode) {
      _colorList = widget.isGameMode ? _gameColorList : _travelColorList;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _colorList,
              stops: const [0.0, 0.4, 0.6, 1.0],
              transform: GradientRotation(_animationController.value * 2 * math.pi / 8),
            ),
          ),
          child: Stack(
            children: [
              // Abstract design elements
              Positioned(
                top: -50,
                right: -20,
                child: CircleContainer(
                  size: screenSize.width * 0.4,
                  color: (widget.isGameMode ? AppTheme.gamePrimary : AppTheme.travelPrimary).withOpacity(0.05),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -50,
                child: CircleContainer(
                  size: screenSize.width * 0.6,
                  color: (widget.isGameMode ? AppTheme.gameSecondary : AppTheme.travelSecondary).withOpacity(0.05),
                ),
              ),
              Positioned(
                top: screenSize.height * 0.3,
                left: -30,
                child: CircleContainer(
                  size: screenSize.width * 0.3,
                  color: (widget.isGameMode ? AppTheme.gameAccent : AppTheme.travelAccent).withOpacity(0.05),
                ),
              ),
              
              // Animated dots
              ..._buildAnimatedDots(screenSize),
              
              // Main content
              if (widget.child != null) widget.child!,
            ],
          ),
        );
      },
    );
  }
  
  List<Widget> _buildAnimatedDots(Size screenSize) {
    final random = math.Random(42); // Fixed seed for consistent positions
    final dots = <Widget>[];
    
    for (int i = 0; i < 15; i++) {
      final size = random.nextDouble() * 10 + 5;
      final initialX = random.nextDouble() * screenSize.width;
      final initialY = random.nextDouble() * screenSize.height;
      
      // Create a moving dot with a slightly different animation phase
      final phase = random.nextDouble() * 2 * math.pi;
      final amplitude = random.nextDouble() * 20 + 10;
      final period = random.nextDouble() * 10 + 5;
      
      final x = initialX + amplitude * math.sin((_animationController.value * 2 * math.pi / period) + phase);
      final y = initialY + amplitude * math.cos((_animationController.value * 2 * math.pi / period) + phase);
      
      final color = widget.isGameMode ? 
        AppTheme.gamePrimary.withOpacity(0.1 + random.nextDouble() * 0.1) :
        AppTheme.travelPrimary.withOpacity(0.1 + random.nextDouble() * 0.1);
      
      dots.add(
        Positioned(
          left: x,
          top: y,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        ),
      );
    }
    
    return dots;
  }
}

/// Helper widget for creating abstract design elements
class CircleContainer extends StatelessWidget {
  final double size;
  final Color color;
  
  const CircleContainer({
    super.key,
    required this.size,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
} 