import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final String? buttonText;
  final bool isBuy;
  Color btnColor;
  Color btnTextColor;
  Color borderColor;
  double height;
  // Widget btnIcon;
  double width;
  double fontSize;
  CustomButton(
      {this.onTap,
      @required this.buttonText,
      this.height = 55,
      this.fontSize = 14,
      // this.width = 150,
      this.width = 1,
      this.btnColor = primaryColor,
      this.borderColor = primaryColor,
      this.btnTextColor = Colors.white,
      // this.btnIcon = const Icon(
      //   Icons.email_outlined,
      //   color: Colors.white,
      // ),
      this.isBuy = false});

  @override
  Widget build(BuildContext context) {
    width = width;
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
      child: Container(
        height: height,
        width: MediaQuery.of(context).size.width * width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            color: btnColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 1)), // changes position of shadow
            ],
            //
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(right: 10.0),
            //   child: btnIcon,
            // ),
            Text(
              buttonText!,
              style: GoogleFonts.poppins(
                color: btnTextColor,
                textStyle: Theme.of(context).textTheme.bodyMedium,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
