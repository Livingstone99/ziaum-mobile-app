import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:switch_app/constants/colors.dart';
import 'package:switch_app/providers/authProvider.dart';
import 'package:switch_app/services/shared_preference.dart';

import 'package:switch_app/widgets/loadingWidget.dart';
import 'package:switch_app/widgets/pinFieldWidget.dart';
import 'package:switch_app/widgets/textWidget.dart';

class OTPScreen extends ConsumerStatefulWidget {
  final bool forgetPassword;
  const OTPScreen({super.key, this.forgetPassword = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  final TextEditingController pinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
      ),
      // backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: "Code de Verification",
              fontSize: 28,
            ),
            SizedBox(
              height: 20,
            ),
            TextWidget(
              text:
                  "Nous avons envoyé un code de vérification au email ${Preference().email} par mail. ",
            ),
            SizedBox(
              height: 20,
            ),
            PinCustomField(
              length: 6,
              pinController: pinController,
              reason: widget.forgetPassword ? "forget_password" : "non",
            ),
            SizedBox(
              height: 20,
            ),

            widget.forgetPassword
                ? Container()
                : RichText(
                    text: TextSpan(
                      text: "I didn't receive OTP, ",
                      style: GoogleFonts.poppins(fontSize: 16, color: dark),
                      children: [
                        TextSpan(
                          text: 'resend the code',
                          style: GoogleFonts.poppins(
                              color: primaryColor, fontSize: 16),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Go back to the previous screen
                              Navigator.pop(context);
                            },
                        ),
                      ],
                    ),
                  ),
            SizedBox(
              height: 20,
            ),
            ref.watch(AuthProvider).loading
                ? Center(child: CustomLoadingWidget())
                : Container()
            // Spacer(),
            // SizedBox(
            //   height: 60,
            // ),
            // CustomButton(buttonText: "Continuer")
          ],
        ),
      ),
    );
  }
}
