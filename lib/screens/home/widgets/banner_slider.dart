import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:zindaonlineschool/core/utils/responsive.dart';

class BannerSlider extends StatelessWidget {
  final List banners;

  const BannerSlider({
    super.key,
    required this.banners,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: banners.length,
      itemBuilder: (context, index, realIndex) {
        final banner = banners[index];

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: NetworkImage(banner.image),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: Responsive.spacing(context, 0.22, min: 130, max: 240),
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: Responsive.value(
          context,
          mobile: 0.92,
          tablet: 0.85,
          desktop: 0.75,
        ),
      ),
    );
  }
}
