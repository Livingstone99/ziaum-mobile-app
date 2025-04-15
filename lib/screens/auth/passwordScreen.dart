
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switch_app/constants/colors.dart';
import 'package:switch_app/providers/authProvider.dart';
import 'package:switch_app/utils/functionalComponent.dart';
import 'package:switch_app/widgets/customSnackbar.dart';
import 'package:switch_app/widgets/custom_textfield.dart';
import 'package:switch_app/widgets/custombutton.dart';
import 'package:switch_app/widgets/loadingWidget.dart';
import 'package:switch_app/widgets/textWidget.dart';

import '../../services/shared_preference.dart';

class PasswordScreen extends ConsumerStatefulWidget {
  const PasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends ConsumerState<PasswordScreen> {
  final TextEditingController emailController =
      TextEditingController(text: Preference().email);

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool showPassword = false;

  // @override

  //   void initState() {
  //     Preference().emailVerified
  //         ? emailController.text = Preference().email
  //         : emailController.text = "";
  //     super.initState();

  // }
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(AuthProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
      ),
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: "Identifiants de connexion",
              fontSize: 28,
            ),
            SizedBox(
              height: 40,
            ),
            TextWidget(
              text: "Remplissez correctement les champs ci-dessous",
            ),
            SizedBox(
              height: 40,
            ),
            CustomTextField(
              labelText: "Votre email",
              hintText: "Soufamidou@gmail.com",
              controller: emailController,
              enableForm: false,
            ),
            CustomTextField(
              labelText: "Mot de passe",
              controller: passwordController,
              prefixIcon: Icon(Icons.lock_outline),
              isPassword: !showPassword,
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
            TextWidget(text: "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character."),
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
            SizedBox(
              height: 70,
            ),
            authState.loading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomLoadingWidget(),
                    ],
                  )
                : CustomButton(
                    buttonText: "Valider et soumettre",
                    onTap: () async {
                      // Check if passwords match
  if (passwordController.text != confirmPasswordController.text) {
    CustomSnackbar.showSnackbar(
        title: "Erreur", message: "Password mismatch");
    return;
  }

  // Check if any field is empty
  if (emailController.text.isEmpty ||
      passwordController.text.isEmpty ||
      confirmPasswordController.text.isEmpty) {
    warnCustomScaffoldMessenger(context,
        text: "Please provide all the required details");
    return;
  }

  // Validate password strength
  // if (!_isPasswordStrong(passwordController.text)) {
  //   CustomSnackbar.showSnackbar(
  //       title: "Erreur",
  //       message:
  //           "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character.");
  //   return;
  // }
                      Map data = ref.read(createAccountData);
                      data.addAll({"password": passwordController.text});
                      await ref.read(AuthProvider.notifier).createAccount(data);
                    },
                  )
          ],
        ),
      ),
    );
  }
}
