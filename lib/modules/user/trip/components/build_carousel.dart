import 'package:flutter/material.dart';
import 'package:jejom/utils/m3_carousel.dart';

class BuildCarousel extends StatefulWidget {
  const BuildCarousel({super.key, required this.photos});

  final List<String> photos;

  @override
  State<BuildCarousel> createState() => _BuildCarouselState();
}

class _BuildCarouselState extends State<BuildCarousel> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: M3Carousel(
          visible: 3,
          slideAnimationDuration: 300, // milliseconds
          titleFadeAnimationDuration: 200, // milliseconds
          children: [
            ...widget.photos.map((url) {
              return {"image": url, "title": ""};
            }),
          ],
        ),
      ),
    );
  }
}
