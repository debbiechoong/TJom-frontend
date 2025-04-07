import 'package:flutter/material.dart';
import 'package:jejom/modules/user/trip/components/get_photo_url.dart';
import 'package:jejom/utils/m3_carousel.dart';
import 'package:jejom/utils/theme/app_theme.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingMedium),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: M3Carousel(
            visible: 3,
            slideAnimationDuration: 300, // milliseconds
            titleFadeAnimationDuration: 200, // milliseconds
            children: [
              ...widget.photos.map((url) {
                return {"image": getPhotoUrl(url), "title": ""};
              }),
            ],
          ),
        ),
      ),
    );
  }
}
