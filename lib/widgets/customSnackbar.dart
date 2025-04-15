import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import 'textWidget.dart';

class CustomSnackbar {
  static void showSnackbar({String? message, String? title, int seconds = 3}) {
    HapticFeedback.vibrate();
    Get.snackbar(
      title!,
      message!,
      snackPosition: SnackPosition.BOTTOM,
      messageText: TextWidget(
        text: message,
        textColor: dark,
      ),
      titleText: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: title,
            textColor: dark,
            fontWeight: FontWeight.bold,
          ),
          const Divider()
        ],
      ),
      backgroundColor: bgColor,
      colorText: dark,
      duration: Duration(seconds: seconds),
      isDismissible: true,
      dismissDirection: DismissDirection.down,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: Duration(milliseconds: 500),
      // backgroundGradient: LinearGradient(
      //   colors: [Colors.blue, Colors.green],
      //   stops: [0.7, 1.0],
      // ),
    );
  }
}
