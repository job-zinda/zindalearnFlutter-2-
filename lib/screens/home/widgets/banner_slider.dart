import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BannerSlider extends StatelessWidget {

  final List banners;

  const BannerSlider({
    super.key,
    required this.banners,
  });

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;

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
        height: height * 0.22,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.92,
      ),
    );
  }
}