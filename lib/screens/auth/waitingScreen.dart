import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:switch_app/constants/colors.dart';
import 'package:switch_app/providers/authProvider.dart';
import 'package:switch_app/widgets/textWidget.dart';

import '../home/homeScreen.dart';

class WaitingScreen extends ConsumerStatefulWidget {
  const WaitingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends ConsumerState<WaitingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(AuthProvider.notifier).getUser();
    });
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Get.offAll(HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
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
              text: "Inscription réussie",
              fontSize: 28,
            ),
            SizedBox(
              height: 40,
            ),
            TextWidget(
              text:
                  "Un mot de passe vous a été envoyé par email pour vous connectez (vous pourrez le changer plus tard).",
            ),
            SizedBox(
              height: 40,
            ),
            TextWidget(
              text: "Votre compte sera activé dans un délai de 48h.",
              fontWeight: FontWeight.w500,
            )
          ],
        ),
      ),
    );
  }
}
