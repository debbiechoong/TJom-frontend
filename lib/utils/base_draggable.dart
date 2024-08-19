import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:jejom/utils/constants/curve.dart';

class BaseDraggableSheet extends StatefulWidget {
  const BaseDraggableSheet(
      {super.key,
      required this.sheetKey,
      required this.controller,
      required this.child,
      this.initialChildSize = 0.0,
      this.minChildSize = 0.0,
      this.sheetPadding = 16});

  final GlobalKey sheetKey;
  final DraggableScrollableController controller;
  final Widget child;
  final double initialChildSize;
  final double minChildSize;
  final double sheetPadding;

  @override
  State<BaseDraggableSheet> createState() => _BaseDraggableSheetState();
}

class _BaseDraggableSheetState extends State<BaseDraggableSheet>
    with SingleTickerProviderStateMixin {
  // final sheetKey = GlobalKey();
  late AnimationController _animationController;
  // late Animation<double> _animation;
  // double _dragExtent = 0.0;
  // late DraggableScrollableController controller;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    widget.controller.addListener(_onChanged);
  }

  @override
  void didChangeDependencies() {
    if (widget.controller.isAttached) {
      _animateSheet(0.5);
    }
    print(widget.controller.isAttached);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.controller.removeListener(_onChanged);
    widget.controller.dispose();
    super.dispose();
  }

  void _onChanged() {
    final currentSize = widget.controller.size;
    if (currentSize <= 0.1) _collapse();
  }

  void _runAnimation(Offset pixelsPerSecond, Size size) {
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _animationController.animateWith(simulation);
  }

  void _collapse() => _animateSheet(0.0);

  void _anchor() => _animateSheet(1.0);

  void _expand() => _animateSheet(1.0);

  void _hide() => _animateSheet(0.0);

  void _animateSheet(double size) {
    widget.controller.animateTo(
      size,
      duration: const Duration(milliseconds: 400),
      curve: EMPHASIZED_DECELERATE,
    );
  }

  DraggableScrollableSheet get sheet =>
      (widget.sheetKey.currentWidget as DraggableScrollableSheet);

  // TODO Sticky header: https://medium.getwidget.dev/creating-a-sticky-header-in-flutter-a-complete-guide-e7842c08db30
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(builder: (context, constraints) {
      // print(
      //     "height is ${constraints.maxHeight}  width is ${constraints.maxWidth}");
      return SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: DraggableScrollableSheet(
          key: widget.sheetKey,
          controller: widget.controller,
          initialChildSize: widget.minChildSize > widget.initialChildSize
              ? widget.minChildSize
              : widget.initialChildSize,
          minChildSize: widget.minChildSize,
          maxChildSize: 0.8,
          expand: true,
          snap: true,
          snapSizes: const [0.5],
          // snapAnimationDuration: const Duration(milliseconds: 100),
          builder: (BuildContext context, ScrollController scrollController) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverPadding(
                    padding:
                        EdgeInsets.symmetric(horizontal: widget.sheetPadding),
                    sliver: widget.child,
                  ),
                ],
              ),
              // child: Padding(
              //     padding:
              //         EdgeInsets.symmetric(horizontal: widget.sheetPadding),
              //     child: widget.child),
            );
          },
        ),
      );
    });
  }
}
