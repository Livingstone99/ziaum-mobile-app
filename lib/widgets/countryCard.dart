import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:get/get.dart';
import 'package:switch_app/providers/configProvider.dart';
import 'package:switch_app/screens/home/TransactionScreen.dart';

import '../models/countryModel.dart';
import 'textWidget.dart';

class CountryCard extends ConsumerWidget {
  final CountryModel? countryModel;
  const CountryCard({super.key, this.countryModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedtransactionCountryProvider.notifier).state =
            countryModel!;
        Get.to(TransactionScreen());
        // Preference().countryCode = countryModel!.code!;
        // Preference().countryId = countryModel!.countryId!;

        // Get.to(const AuthScreen(), transition: Transition.fadeIn);
      },
      child: Container(
        width: 70,
        height: 60,
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blueGrey)),
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              // padding: const EdgeInsets.only(right: 8),
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    countryModel!.image!,
                  ),
                ),
              ),
            ),
            TextWidget(
              text: countryModel!.countryCode,
              fontSize: 12,
              textColor: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}

Widget bottomCountry(
  WidgetRef ref,
  CountryModel countryModel, {
  String diaspora = "diaspora",
}) {
  return GestureDetector(
    onTap: () {
      if (diaspora == "diaspora") {
        ref.read(selectedCountryProvider.notifier).state = countryModel;
        // Get.back();
      }
      {
        ref.read(selectedtransactionCountryProvider.notifier).state =
            countryModel;
        ref.read(selectedOperatorProvider.notifier).state = OperatorModel();
        Get.back();
      }

      // Preference().countryCode = countryModel!.code!;
      // Preference().countryId = countryModel!.countryId!;

      // Get.to(const AuthScreen(), transition: Transition.fadeIn);
    },
    child: Container(
      width: 70,
      height: 60,
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(3.0),

      // padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // padding: const EdgeInsets.only(right: 8),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  countryModel.image!,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          TextWidget(
            text: countryModel.countryCode,
            fontSize: 14,
            textColor: Colors.black,
          ),
          SizedBox(
            width: 10,
          ),
          TextWidget(
            text: countryModel.countryName,
            fontSize: 16,
            textColor: Colors.black,
          )
        ],
      ),
    ),
  );
}
