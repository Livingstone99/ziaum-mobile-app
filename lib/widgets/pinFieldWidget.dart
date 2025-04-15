import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:switch_app/providers/authProvider.dart';
import 'package:switch_app/screens/auth/passwordScreen.dart';
import 'package:switch_app/screens/auth/signupScreen.dart';

import '../constants/colors.dart';

class PinCustomField extends ConsumerStatefulWidget {
  final TextEditingController? pinController;
  final int length;
  final bool autoFocus;
  final bool reaOnly;
  final String reason;

  const PinCustomField(
      {super.key,
      this.pinController,
      this.autoFocus = true,
      this.reaOnly = false,
      this.reason = "",
      this.length = 6});

  @override
  _PinCustomFieldState createState() => _PinCustomFieldState();
}

class _PinCustomFieldState extends ConsumerState<PinCustomField> {
  String currentText = "";
  bool loading = false;

  StreamController<ErrorAnimationType>? errorController;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: bgColor,
        width: MediaQuery.of(context).size.width,
        // padding: const EdgeInsets.symmetric(vertical: 10.0),

        child: PinCodeTextField(
          backgroundColor: bgColor,
          appContext: context,
          readOnly: widget.reaOnly,
          controller: widget.pinController,
          pastedTextStyle: const TextStyle(
            color: Color.fromRGBO(66, 66, 66, 1),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          length: widget.length,
          autoFocus: widget.autoFocus,
          obscureText: true,
          obscuringCharacter: '*',
          // obscuringWidget: FlutterLogo(
          //   size: 24,
          // ),
          blinkWhenObscuring: true,
          animationType: AnimationType.fade,
          validator: (v) {
            if (v!.length == 4) {
              // print(" i was here");
              // Get.to(PasswordScreen());
            }
            return null;
            // if (v!.length < 6) {
            //   return "remaining"
            //       " ${6 - v.length}";
            // } else {
            //   return null;
            // }
          },
          pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              inactiveColor: greyColorReg,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              fieldHeight: 40,
              fieldOuterPadding: const EdgeInsets.all(2),
              fieldWidth: 50,
              activeFillColor: Color.fromRGBO(231, 251, 228, 1),
              inactiveFillColor: bgColor,
              activeColor: primaryColor,
              selectedFillColor: bgColor),
          // selectedColor: primaryColor,

          // cursorColor: Colors.black,
          animationDuration: const Duration(milliseconds: 300),
          enableActiveFill: true,
          errorAnimationController: errorController,
          keyboardType: TextInputType.number,
          boxShadows: const [
            BoxShadow(
              offset: Offset(0, 1),
              color: Colors.black12,
              blurRadius: 10,
            )
          ],
          onCompleted: (v) async {
            FocusScope.of(context).unfocus();
            print(widget.reason);
            await ref
                .read(AuthProvider.notifier)
                .verifyOtp(v, reason: widget.reason);
          },
          // onTap: () {
          //   //debugPrint("Pressed");
          // },
          onChanged: (value) {
            debugPrint(value);
            setState(() {
              currentText = value;
            });
          },
          beforeTextPaste: (text) {
            //debugPrint("Allowing to paste $text");
            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
            //but you can show anything you want here, like your pop up saying wrong paste format or etc
            return true;
          },
        ));
  }
}
