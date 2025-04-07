import 'package:flutter/material.dart';
import 'package:jejom/utils/theme/app_theme.dart';

/// A swipeable page container that standardizes gesture navigation
/// Allows users to navigate back by swiping from left edge
class SwipeablePage extends StatefulWidget {
  /// Main content of the page
  final Widget child;
  
  /// Whether to enable swipe-to-go-back gesture
  final bool enableSwipeBack;
  
  /// Callback when swipe back gesture completes
  final VoidCallback? onSwipeBack;
  
  /// Whether to show a visual indicator for swipe back
  final bool showBackIndicator;
  
  /// Background color for the page
  final Color? backgroundColor;

  const SwipeablePage({
    super.key,
    required this.child,
    this.enableSwipeBack = true,
    this.onSwipeBack,
    this.showBackIndicator = true,
    this.backgroundColor,
  });

  @override
  State<SwipeablePage> createState() => _SwipeablePageState();
}

class _SwipeablePageState extends State<SwipeablePage> {
  final _dragController = DragController();

  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableSwipeBack) {
      return widget.child;
    }

    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: Stack(
        children: [
          widget.child,
          // Visual indicator for swipe back
          if (widget.showBackIndicator)
            AnimatedBuilder(
              animation: _dragController,
              builder: (context, _) {
                final opacity = (_dragController.value / 0.3).clamp(0.0, 1.0);
                return IgnorePointer(
                  child: Opacity(
                    opacity: opacity * 0.3,
                    child: Container(
                      width: 40 * opacity,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppTheme.travelPrimary.withOpacity(0.3),
                            AppTheme.travelPrimary.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    // Only detect edge swipes (from left edge)
    if (details.localPosition.dx < 20) {
      _dragController.start();
    }
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!_dragController.isActive) return;
    
    // Calculate drag value (0.0 to 1.0) based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final dragDistance = details.localPosition.dx;
    final dragValue = (dragDistance / screenWidth).clamp(0.0, 1.0);
    
    _dragController.update(dragValue);
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_dragController.isActive) return;
    
    // Detect if the swipe was fast enough or far enough
    final velocity = details.primaryVelocity ?? 0;
    final dragValue = _dragController.value;
    
    if (velocity > 300 || dragValue > 0.3) {
      _dragController.complete();
      widget.onSwipeBack?.call();
      Navigator.of(context).maybePop();
    } else {
      _dragController.cancel();
    }
  }
}

/// Controller for drag gestures
class DragController extends ChangeNotifier {
  double _value = 0.0;
  bool _isActive = false;

  double get value => _value;
  bool get isActive => _isActive;

  void start() {
    _isActive = true;
    _value = 0.0;
    notifyListeners();
  }

  void update(double value) {
    if (!_isActive) return;
    _value = value;
    notifyListeners();
  }

  void complete() {
    _isActive = false;
    _value = 0.0;
    notifyListeners();
  }

  void cancel() {
    _isActive = false;
    _value = 0.0;
    notifyListeners();
  }
}

/// Extension to wrap any page with swipeable navigation
extension SwipeablePageExtension on Widget {
  Widget withSwipeNavigation({
    bool enableSwipeBack = true,
    VoidCallback? onSwipeBack,
    bool showBackIndicator = true,
    Color? backgroundColor,
  }) {
    return SwipeablePage(
      enableSwipeBack: enableSwipeBack,
      onSwipeBack: onSwipeBack,
      showBackIndicator: showBackIndicator,
      backgroundColor: backgroundColor,
      child: this,
    );
  }
} 