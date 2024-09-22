import 'dart:io'; // Add this to handle local file paths
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/model/dashboard_page_model/dashboard_page_model.dart';

class BannerCarousel extends StatefulWidget {
  final List<Banners> banners;

  const BannerCarousel({super.key, required this.banners});

  @override
  BannerCarouselState createState() => BannerCarouselState();
}

class BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0; // Track the current index
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 320 / 211,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index; // Update the current index
              });
            },
          ),
          items: widget.banners.map((banner) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildImage(banner.bannerUrl),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.banners.length, (index) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? AppColor.navyBlue : Colors.grey,
              ),
            );
          }),
        )
      ],
    );
  }

  // Function to build the image
  Widget _buildImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const Center(
        child: Icon(
          Icons.broken_image,
          color: Colors.grey,
          size: 40,
        ),
      );
    }

    if (imagePath.startsWith('http')) {
      // Image from network (API)
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.broken_image,
              color: Colors.grey,
              size: 40,
            ),
          );
        },
      );
    } else {
      // Image from local storage
      final File imageFile = File(imagePath);
      return Image.file(
        imageFile,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.broken_image,
              color: Colors.grey,
              size: 40,
            ),
          );
        },
      );
    }
  }
}
