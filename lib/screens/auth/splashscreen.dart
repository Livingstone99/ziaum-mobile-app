import 'dart:async';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:switch_app/providers/configProvider.dart';
import 'package:switch_app/screens/auth/authscreen.dart';

import '../../constants/colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Future<void> requestNotificationPermissions() async {
  //   final settings = await _firebaseMessaging.requestPermission(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //     provisional:
  //         false, // Set this to true for provisional authorization (iOS 12+)
  //   );

  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print('Notification permissions granted.');
  //   } else {
  //     print('Notification permissions denied.');
  //   }
  // }

  @override
  void initState() {
    // requestNotificationPermissions();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(ConfigProvider.notifier).getAllCountry();
      await ref.read(ConfigProvider.notifier).getAllOperator();

      // await Future.wait([ref.read(ConfigProvider.notifier).bannerLists()]);
    });

    Timer(const Duration(seconds: 2), () {
  Get.offAll(AuthScreen());
      // ref.read(ConfigProvider.notifier).instantiateConfig();
      // ref.read(ConfigProvider.notifier).getCountry().then((value) {
      //   final configProvider = ref.read(ConfigProvider);
      //   if (configProvider.allCountries!.isNotEmpty) {
      //     if (Preference().loggedIn) {
      //       Get.off(const HomeScreen());
      //       return;
      //     } else {
      //       Get.off(const SelectCountryScreen());
      //       return;
      //     }
      //   }
      // });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/png/splashscreen.png",
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(49, 191, 27, 1),
              Color.fromRGBO(217, 217, 217, 1)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.8, 0.2],
            // tileMode: TileMode.mirror,
          ),
        ),
        child: Column(children: [
          Spacer(),
          // Image.asset(
          //   "assets/png/zlogo.png",
          //   height: 200,
          //   width: 200,
          // ),
          // SvgPicture.asset("assets/svg/splash-image.svg"),
          Image.asset(
            "assets/png/splash-image.png",
            // height: 200,
            // width: 200,
          ),
          Spacer()
        ]),
      ),
    );
  }
}
