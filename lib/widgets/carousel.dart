
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switch_app/models/countryModel.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../constants/colors.dart';

class CarouselWidget extends ConsumerStatefulWidget {
  final double heightRatio;
  final List<AdsModel>? adsList;

  const CarouselWidget({super.key, this.adsList, this.heightRatio = 0.2});

  @override
  ConsumerState<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends ConsumerState<CarouselWidget> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: CarouselSlider(
            carouselController: _controller,
            options: CarouselOptions(
              height: 176,
              viewportFraction: 0.85,
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.scale,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
            items: widget.adsList!.map((item) {
              final index = widget.adsList!.indexOf(item);
              print(item.image);
              return GestureDetector(
                onTap: () async {
                  if (item.link!.isNotEmpty) await launchUrlString(item.link!);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 8.0),
                    //   child: TextWidget(
                    //     text: item.title,
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.w500,
                    //     maxLine: 1,
                    //     overflow: TextOverflow.ellipsis,
                    //   ),
                    // ),
                    Container(
                      height: MediaQuery.of(context).size.height *
                          widget.heightRatio *
                          0.8, // Restrict image height
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            item.image.toString(),
                          ),
                        ),
                      ),
                    ),
                    // TextWidget(
                    //   text: item.details,
                    //   maxLine: 1,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.adsList!.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentPage == entry.key ? primaryColor : primaryColor2,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
