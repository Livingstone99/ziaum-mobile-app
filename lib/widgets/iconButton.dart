import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomIconButton extends StatelessWidget {
  final void Function()? onTap;

  Color btnColor;
  // double height;
  // double width;
  double size;
  IconData? icon;
  Color iconColor;
  Color borderColor;
  CustomIconButton(
      {this.icon,
      this.onTap,
      // this.height = 60,
      this.size = 36,
      // this.width = 60,
      this.iconColor = dark,
      this.btnColor = iconBtnColor,
      this.borderColor = primaryColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: size,
          width: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: btnColor,
              // shape: BoxShape.circle,
              // border: Border.all(color: borderColor, width: 1.5)
              borderRadius: BorderRadius.circular(4)),
          child: Center(
              child: Icon(
            icon,
            size: 20,
            color: iconColor,
          ))),
    );
  }
}
