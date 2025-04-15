import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../utils/noSpaceFormatter.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final void Function()? onTap;
  final void Function()? onComplete;
  final void Function(String value)? onChange;
  final String? hintText;
  final String? errorText;
  final TextInputType? textInputType;
  final int? maxLine;
  final int maxLimit;
  final double letterspacing;
  final double? height;
  final double borderRadius;
  final String? obscureCharater;
  final bool isPassword;

  final TextAlign textAlign;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputAction? textInputAction;
  final bool? isPhoneNumber;
  final bool space;
  final bool autoFocus;
  final bool enableForm;
  final bool? isValidator;
  final String? validatorMessage;
  final String? labelText;
  final Color? fillColor;
  final Color? bordersideColor;
  final Color? cursorColor;
  final double? cursorHeight;
  final double? cursorWidth;

  final TextCapitalization? capitalization;

  const CustomTextField({
    super.key,
    this.controller,
    this.isPassword = false,
    this.bordersideColor = greyColorReg,
    this.onTap,
    this.onComplete,
    this.obscureCharater = "⦁",
    this.onChange,
    this.enableForm = true,
    this.hintText,
    this.labelText,
    this.textInputType,
    this.space = true,
    this.maxLine,
    this.suffixIcon,
    this.prefixIcon,
    this.borderRadius = 10,
    this.letterspacing = 0,
    this.errorText,
    this.textInputAction,
    this.isPhoneNumber = false,
    this.autoFocus = false,
    this.isValidator = false,
    this.maxLimit = 100,
    this.height,
    this.textAlign = TextAlign.start,
    this.validatorMessage,
    this.capitalization = TextCapitalization.none,
    this.fillColor = bgColor,
    this.cursorColor,
    this.cursorHeight,
    this.cursorWidth,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        child: TextFormField(
          style: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.headlineLarge,
            fontSize: 18,
            letterSpacing: letterspacing,
            height: 0.5,
            fontWeight: FontWeight.w400,
          ),
          onEditingComplete: onComplete,
          onChanged: onChange,
          obscureText: isPassword,
          obscuringCharacter: obscureCharater!,
          controller: controller,
          enabled: enableForm,
          autofocus: autoFocus,
          maxLines: maxLine ?? 1,
          textAlign: textAlign,
          textCapitalization: capitalization!,
          maxLength: isPhoneNumber! ? 15 : null,
          keyboardType: textInputType ?? TextInputType.text,
          textInputAction: textInputAction ?? TextInputAction.next,
          cursorColor: cursorColor ??
              Theme.of(context).primaryColor, // Custom cursor color
          cursorHeight: cursorHeight ?? 24.0, // Custom cursor height
          cursorWidth: cursorWidth ?? 2.0, // Custom cursor width
          onFieldSubmitted: (v) {
            // FocusScope.of(context).requestFocus(nextNode);
          },
          inputFormatters: [
            (space) ? DoNothing() : NoSpaceFormatter(),
            LengthLimitingTextInputFormatter(maxLimit),
            isPhoneNumber!
                ? FilteringTextInputFormatter.digitsOnly
                : FilteringTextInputFormatter.singleLineFormatter
          ],
          validator: (input) {
            if (input!.isEmpty) {
              if (isValidator!) {
                return validatorMessage ?? "";
              }
            }
            return null;
          },
          decoration: InputDecoration(
            errorText: errorText,
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: greyColorReg)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: bordersideColor!)),
            labelText: labelText,
            labelStyle: GoogleFonts.lato(
              textStyle: Theme.of(context).textTheme.headlineLarge,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            hintText: hintText ?? '',
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            hintStyle: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.bodySmall,
              color: greyColor,
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 15),
            isDense: true,
            counterText: '',
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor)),
            errorStyle: const TextStyle(height: 1.5),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
