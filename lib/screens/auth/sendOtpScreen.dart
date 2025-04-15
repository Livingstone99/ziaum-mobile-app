import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:switch_app/providers/authProvider.dart';
import 'package:switch_app/screens/auth/otpScreen.dart';
import 'package:switch_app/services/shared_preference.dart';
import 'package:switch_app/widgets/customSnackbar.dart';
import 'package:switch_app/widgets/custombutton.dart';
import 'package:switch_app/widgets/loadingWidget.dart';

import '../../utils/functionalComponent.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/textWidget.dart';

class SendOtpScreen extends ConsumerStatefulWidget {
  final bool forgotPassword;
  const SendOtpScreen({super.key, this.forgotPassword = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends ConsumerState<SendOtpScreen> {
  bool showPassword = false;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authPorvider = ref.watch(AuthProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Row(
              //   children: [
              //     SizedBox(
              //       width: MediaQuery.of(context).size.width * 0.33,
              //       child: CustomTextField(
              //         prefixIcon: Row(
              //           children: [
              //             Padding(
              //               padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //               child: Image.asset(
              //                 "assets/png/nig.png",
              //                 width: 40,
              //               ),
              //             ),
              //             TextWidget(
              //               text: "+234",
              //             )
              //           ],
              //         ),
              //         enableForm: false,
              //         suffixIcon: Icon(Icons.arrow_drop_down_circle_outlined),
              //         // hintText: ".......",
              //       ),
              //     ),
              //     Spacer(),
              //     SizedBox(
              //       width: MediaQuery.of(context).size.width * 0.55,
              //       child: CustomTextField(
              //         labelText: "Numero de telephone",
              //         textInputType: TextInputType.phone,
              //         maxLimit: 10,
              //       ),
              //     )
              //   ],
              // ),
              TextWidget(
                text: widget.forgotPassword
                    ? "Mot de passe oubile"
                    : "Bienvenue sur Ziaum",
                fontSize: 20,
              ),
              Spacer(),
              SizedBox(height: 20),
              TextWidget(
                text: "Veuillez entrer votre email pour continuer",
                fontSize: 16,
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: controller,
                labelText: "Email",
                textInputType: TextInputType.emailAddress,
                space: false,
                autoFocus: true,
              ),
              widget.forgotPassword
                  ? SizedBox()
                  : Column(children: [
                      SizedBox(height: 20),
                      CustomTextField(
                        labelText: "Mot de passe",
                        controller: passwordController,
                        prefixIcon: Icon(Icons.lock_outline),
                        isPassword: !showPassword,
                        obscureCharater: "●",
                        suffixIcon: IconButton(
                          onPressed: () {
                            print("i passess");

                            setState(() {
                              showPassword = !showPassword;
                            });
                            print(showPassword);
                          },
                          icon: showPassword
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility_outlined),
                        ),
                        // hintText: ".......",
                      ),
                      SizedBox(height: 20),
                      TextWidget(
                        text:
                            "Le mot de passe peut contenir au moins une lettre majuscule, une lettre minuscule, un chiffre et un caractère spécial.",
                        fontSize: 11,
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        labelText: "Repeter le Mot de passe",
                        prefixIcon: Icon(Icons.lock_outline),
                        isPassword: !showPassword,
                        controller: confirmPasswordController,
                        obscureCharater: "●",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          icon: Icon(showPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                        ),
                        // hintText: ".......",
                      ),
                    ]),
              Spacer(),
              authPorvider.loading
                  ? Center(child: CustomLoadingWidget())
                  : CustomButton(
                      buttonText: "continuer",
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        if (controller.text.isEmpty ||
                            !controller.text.contains("@")) {
                          CustomSnackbar.showSnackbar(
                              title: "ERREUR",
                              message: "fournir une adresse e-mail valide");
                          return;
                        }

                        Preference().email = (controller.text).toLowerCase();
                        // if (widget.forgotPassword) {
                        //   return;
                        // }
                        String reason =
                            widget.forgotPassword ? "forget_password" : "non";

                        if (!widget.forgotPassword) {
                          if (passwordController.text !=
                              confirmPasswordController.text) {
                            CustomSnackbar.showSnackbar(
                                title: "Erreur",
                                message: "Erreur de mot de passe");
                            return;
                          }

                          // Check if any field is empty
                          if (passwordController.text.isEmpty ||
                              confirmPasswordController.text.isEmpty) {
                            warnCustomScaffoldMessenger(context,
                                text:
                                    "Veuillez fournir toutes les informations demandées");
                            return;
                          }
                          ref.read(beforeAccountData.notifier).state = {
                            "password": passwordController.text
                          };
                        }
                        ref
                            .read(AuthProvider.notifier)
                            .sendOtp(controller.text, reason: reason)
                            .then((value) {
                          if (!value) {
                            Get.to(OTPScreen(
                              forgetPassword: widget.forgotPassword,
                            ));
                          }
                        });
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }
}
