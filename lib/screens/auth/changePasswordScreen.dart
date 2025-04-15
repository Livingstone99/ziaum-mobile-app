import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:switch_app/providers/authProvider.dart';
import 'package:switch_app/services/shared_preference.dart';
import 'package:switch_app/widgets/customSnackbar.dart';
import 'package:switch_app/widgets/custombutton.dart';
import 'package:switch_app/widgets/loadingWidget.dart';

import '../../widgets/custom_textfield.dart';
import '../../widgets/textWidget.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  bool _isPasswordStrong(String password) {
    final regex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return regex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    final authPorvider = ref.watch(AuthProvider);

    final TextEditingController oldPassword = TextEditingController();
    final TextEditingController newPassword = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          text: 'Change Password',
          fontSize: 18,
          textColor: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
      ),
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

              SizedBox(height: 20),
              TextWidget(
                text:
                    "Pour mettre à jour le mot de passe de cet e-mail ${Preference().email}",
                fontSize: 16,
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: oldPassword,
                labelText: "old password",
                textInputType: TextInputType.visiblePassword,
                // space: false,
                autoFocus: true,
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: newPassword,
                labelText: "new password",
                textInputType: TextInputType.visiblePassword,
                // space: false,
                autoFocus: true,
              ),
              Spacer(),
              authPorvider.loading
                  ? CustomLoadingWidget()
                  : CustomButton(
                      buttonText: "continuer",
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        // if(oldPassword.text == newPassword.text){
                        //    CustomSnackbar.showSnackbar(
                        //       title: "Erreur",
                        //       message:
                        //           "old and new ");
                        //   return;
                        // }
                        // if (!_isPasswordStrong(newPassword.text)) {
                        //   CustomSnackbar.showSnackbar(
                        //       title: "Erreur",
                        //       message:
                        //           "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character.");
                        //   return;
                        // }

                        await ref
                            .read(AuthProvider.notifier)
                            .changePassword(newPassword.text, oldPassword.text);
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }
}
