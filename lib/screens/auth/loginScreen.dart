import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:switch_app/constants/colors.dart';
import 'package:switch_app/providers/authProvider.dart';
import 'package:switch_app/screens/auth/sendOtpScreen.dart';
import 'package:switch_app/services/shared_preference.dart';
import 'package:switch_app/widgets/customSnackbar.dart';
import 'package:switch_app/widgets/custom_textfield.dart';
import 'package:switch_app/widgets/custombutton.dart';
import 'package:switch_app/widgets/loadingWidget.dart';
import 'package:switch_app/widgets/textWidget.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool showPassword = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authstate = ref.watch(AuthProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          color: dark,
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: bgColor,
      ),
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: "Bon retour chez Ziaum",
              fontSize: 21,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(
              height: 20,
            ),
            TextWidget(
              text: "Entrez vos informations pour vous connecter ",
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
            SizedBox(
              height: 20,
            ),

            CustomTextField(
              labelText: "Entrer votre email",
              hintText: "johndoe@gmail.com",
              controller: emailController,
              textInputType: TextInputType.emailAddress,
              space: false,
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextField(
              labelText: "Mot de passe",
              prefixIcon: Icon(Icons.lock_outline),
              isPassword: !showPassword,
              obscureCharater: "●",
              controller: passwordController,
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

            SizedBox(
              height: 50,
            ),
            authstate.loading
                ? Center(
                    child: CustomLoadingWidget(),
                  )
                : CustomButton(
                    buttonText: "Continuer",
                    onTap: () async {
                      if (emailController.text.isEmpty ||
                          passwordController.text.trim().isEmpty) {
                        CustomSnackbar.showSnackbar(
                            title: "Erreur",
                            message: "provide all required details");
                        return;
                      }
                      Preference().email = (emailController.text).toLowerCase();
                      Map data = {
                        'email': (emailController.text).toLowerCase(),
                        'password': passwordController.text,
                      };
                      await ref.read(AuthProvider.notifier).login(data);
                      // Get.to(WaitingScreen());
                    },
                  ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Spacer(),
                TextButton(
                  onPressed: () {
                    Get.to(SendOtpScreen(
                      forgotPassword: true,
                    ));
                  }, // Call the provided onPressed function
                  child: Text(
                    'Mot de passe oublie',
                    style: GoogleFonts.poppins(
                      color: primaryColor, // Customize the text color
                      fontSize: 14, // Customize the font size
                      decoration: TextDecoration
                          .underline, // Add underline for a link-like appearance
                    ),
                  ),
                ),
              ],
            )
            // Spacer()
          ],
        ),
      ),
    );
  }
}
