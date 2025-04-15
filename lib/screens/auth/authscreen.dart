import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:switch_app/constants/colors.dart';
import 'package:switch_app/screens/auth/loginScreen.dart';
import 'package:switch_app/screens/auth/sendOtpScreen.dart';
import 'package:switch_app/widgets/custombutton.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 50),
            Center(
              child: Image.asset(
                "assets/png/zlogo.png",
                height: 100,
                width: 100,
              ),
            ),
            Spacer(),
            CustomButton(
              buttonText: "Créer son compte",
              onTap: () {
                Get.to(SendOtpScreen());
              },
            ),
            SizedBox(height: 20),
            CustomButton(
              buttonText: "Se connecter",
              btnTextColor: secondaryColor,
              btnColor: bgColor,
              borderColor: secondaryColor,
              onTap: () {
                Get.to(LoginScreen());
              },
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
