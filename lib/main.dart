import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/route_manager.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:switch_app/firebase_options.dart';
import 'package:switch_app/screens/auth/splashscreen.dart';

import 'services/shared_preference.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'settings/themeData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  initializeDateFormatting();
  await Preference().init();
  await dotenv.load(fileName: ".env");
  await Intercom.instance.initialize('spun6s0t',
      iosApiKey: 'ios_sdk-33ec51d9b448830bee03908bca0398ac9b3634ff',
      androidApiKey: 'android_sdk-52f7088722c877f1154ad199f1a05bdae43e98ff');
  Preference().clear();
//Remove this method to stop OneSignal Debugging
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize(dotenv.get("SIGNAL_APP_ID"));

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //Assign publishable key to flutter_stripe
  Stripe.publishableKey = dotenv.get('STRIPEPUBKEY');
  // Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      // theme: ThemeData(
      //   colorScheme:
      //       ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 184, 255, 209)),
      //   useMaterial3: true,
      // ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('fr'), // French
      ],
      home: const SplashScreen(),
    );
  }
}
