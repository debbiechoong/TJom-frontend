import 'dart:ui';

import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double padding;
  final double? width;
  final double? height;
  final double? marginBottom;

  const GlassContainer(
      {super.key,
      required this.child,
      this.padding = 16.0,
      this.width,
      this.height,
      this.marginBottom});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: marginBottom ?? 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: width,
            height: height,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromARGB(49, 217, 217, 217),
                  Color.fromARGB(49, 115, 115, 115),
                ],
              ),
              borderRadius: BorderRadius.circular(16.0),
              // border: Border.all(
              //   width: 2,
              //   color: Colors.white.withOpacity(0.3),
              // ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
