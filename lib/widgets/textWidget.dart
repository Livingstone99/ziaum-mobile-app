import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends ConsumerWidget {
  final String? text;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final TextOverflow? overflow;
  final TextAlign textAlign;
  final int maxLine;
  final double height;
  final double letterspacing;

  const TextWidget(
      {super.key,
      this.text,
      this.fontSize = 15,
      this.maxLine = 4,
      this.height = 0,
      this.letterspacing = 1,
      this.overflow,
      this.textAlign = TextAlign.start,
      this.fontWeight = FontWeight.w300,
      this.textColor = Colors.black});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      text!,
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLine,
      style: GoogleFonts.poppins(
        color: textColor,
        textStyle: Theme.of(context).textTheme.bodyMedium,
        fontSize: fontSize,
        height: height,
        letterSpacing: letterspacing,
        fontWeight: fontWeight,
      ),
    );
  }
}
