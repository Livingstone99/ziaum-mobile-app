import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:switch_app/screens/home/settingScreen.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../constants/colors.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../providers/authProvider.dart';
import '../screens/auth/authscreen.dart';
import '../screens/auth/splashscreen.dart';
import '../services/shared_preference.dart';

String decryptAESCryptoJS(String encrypted) {
  try {
    Uint8List encryptedBytesWithSalt = base64.decode(encrypted);

    Uint8List encryptedBytes =
        encryptedBytesWithSalt.sublist(16, encryptedBytesWithSalt.length);
    final salt = encryptedBytesWithSalt.sublist(8, 16);
    var keyndIV = deriveKeyAndIV(dotenv.env['HASHKEY']!, salt);
    final key = encrypt.Key(keyndIV.item1);
    final iv = encrypt.IV(keyndIV.item2);

    final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
    final decrypted =
        encrypter.decrypt64(base64.encode(encryptedBytes), iv: iv);
    print("was here");
    print(decrypted);
    return decrypted;
  } catch (error) {
    throw error;
  }
}

Tuple2<Uint8List, Uint8List> deriveKeyAndIV(String passphrase, Uint8List salt) {
  var password = createUint8ListFromString(passphrase);
  Uint8List concatenatedHashes = Uint8List(0);
  Uint8List currentHash = Uint8List(0);
  bool enoughBytesForKey = false;
  Uint8List preHash = Uint8List(0);

  while (!enoughBytesForKey) {
    int preHashLength = currentHash.length + password.length + salt.length;
    if (currentHash.length > 0)
      preHash = Uint8List.fromList(currentHash + password + salt);
    else
      preHash = Uint8List.fromList(password + salt);

    currentHash = Uint8List.fromList(md5.convert(preHash).bytes);
    // md5.convert(preHash).bytes;
    concatenatedHashes = Uint8List.fromList(concatenatedHashes + currentHash);
    if (concatenatedHashes.length >= 48) enoughBytesForKey = true;
  }

  var keyBtyes = concatenatedHashes.sublist(0, 32);
  var ivBtyes = concatenatedHashes.sublist(32, 48);
  return new Tuple2(keyBtyes, ivBtyes);
}

Uint8List createUint8ListFromString(String s) {
  var ret = new Uint8List(s.length);
  for (var i = 0; i < s.length; i++) {
    ret[i] = s.codeUnitAt(i);
  }
  return ret;
}

Future<Map> readJsonFile(String filePath) async {
  final String response = await rootBundle.loadString('assets/config/en.json');
  final data = await json.decode(response);
  return data;
}

void onShare(BuildContext context, String? text, String? subject) async {
  // A builder is used to retrieve the context immediately
  // surrounding the ElevatedButton.
  //
  // The context's `findRenderObject` returns the first
  // RenderObject in its descendent tree when it's not
  // a RenderObjectWidget. The ElevatedButton's RenderObject
  // has its position and size after it's built.
  final box = context.findRenderObject() as RenderBox?;

  // if (imagePaths.isNotEmpty) {
  //   await Share.shareFiles(imagePaths,
  //       text: text,
  //       subject: subject,
  //       sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  // } else {
  await Share.share(text!,
      subject: subject,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  // }
}

String formatDate(String inputDate) {
  String refinedDate = inputDate;
  if (inputDate.length > 10) {
    refinedDate = inputDate.substring(0, 10);
  }
  // Split the input date into year, month, and day components
  List<String> dateComponents = refinedDate.split('-');
  int year = int.parse(dateComponents[0]);
  int month = int.parse(dateComponents[1]);
  int day = int.parse(dateComponents[2]);

  // Create a list of month names
  List<String> monthNames = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  // Get the month name
  String monthName = monthNames[month - 1];

  // Get the day with the appropriate suffix (e.g., 1st, 2nd, 3rd, 4th)
  String dayWithSuffix = day.toString();
  if (day >= 11 && day <= 13) {
    dayWithSuffix += "th";
  } else {
    switch (day % 10) {
      case 1:
        dayWithSuffix += "st";
        break;
      case 2:
        dayWithSuffix += "nd";
        break;
      case 3:
        dayWithSuffix += "rd";
        break;
      default:
        dayWithSuffix += "th";
        break;
    }
  }

  // Format the date string
  String formattedDate = '$dayWithSuffix of $monthName, $year';

  return formattedDate;
}

int generateRandom11DigitNumber() {
  final random = Random();
  // Generate a random number between 0 and 999,999,999,999 (0 and 10^11 - 1)
  int randomNumber = random.nextInt(100000000000);
  return randomNumber;
}

void handleStatusCode(num statusCode) {
  // Reset the state of your providers or clear user-specific data here
  // container.refresh(userProvider);
  // container.refresh(someOtherProvider);

  if (statusCode == 401) {
    Preference().clear();
    Get.offAll(() => const SplashScreen());
    // toast message
    toastPopup(message: "Votre compte est connecté à un autre appareil");
  }
}

void toastPopup({String? message}) {
  Fluttertoast.showToast(
      msg: message!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: const Color.fromARGB(255, 248, 218, 216),
      textColor: dark,
      fontSize: 16.0);
}

String encrpytPin(String? pin) {
  const Map<int, String> keys = {
    1: "BB",
    2: "DD",
    3: "FF",
    4: "HH",
    5: "AB",
    6: "CD",
    7: "DF",
    8: "AG",
    9: "XY",
    0: "SO",
  };
  String encryptedPin = "";
  pin!.split("").forEach((char) {
    //debugPrint(keys[int.parse(char)]);
    encryptedPin += keys[int.parse(char)]!;
  });
  // for (int i = 0; i < pin!.length; i++) {
  //   encryptedPin += keys[pin[i]];
  // }

  return encryptedPin;

  // return pin.substring(0, 3) + "****" + pin.substring(pin.length - 3);
}

bool validateQRCode(String createdAt) {
  DateTime dateTime = DateTime.parse(createdAt);

  final difference = DateTime.now().difference(dateTime);

  if (difference.inSeconds > 0) {
    return true;
  }
  final seconds = difference.inSeconds;
  print(seconds);
  return seconds >= 30;
}

Future<String?> getOneSignalPlayerId() async {
  final status = await OneSignal.User.getOnesignalId();
  return status;
}

Future<void> handleLogin() async {
  // OneSignal.logout();
  if (Preference().userId == "") return;

  await OneSignal.login(Preference().userId);
  handleSendTags();
}

Future<void> unsubscribedUser() async {
  if (Preference().userId == "") return;
  OneSignal.User.pushSubscription.optOut();
}

Future<void> updatePushToken(WidgetRef ref) async {
  OneSignal.User.pushSubscription.optIn();
  print("get external id");
  print(await OneSignal.User.getExternalId());
  String token = OneSignal.User.pushSubscription.token!;

  Map<String, dynamic> data = {"pushToken": token};
  if (token != "") await ref.read(AuthProvider.notifier).updateUser(data);
}

void logoutUser() async {
  // Clear user preferences
     Preference().clear();
  // var providers = ref.container.getAllProviderElements();
  // for (var element in providers) {
  //   element.invalidateSelf();
  // }

  // Logout from OneSignal
  await OneSignal.logout();
  Get.offAll(AuthScreen());
}

void handleSendTags() async {
  await OneSignal.User.addTagWithKey("userId", Preference().userId);
}

String responseToString(dynamic response) {
  // Get the values from the map and join them with a new line separator
  if (response is String &&
      response.contains(
          RegExp(r'<\s*\/?\s*html|<\s*\/?\s*body', caseSensitive: false))) {
    return "Something went wrong";
  }
  return response.values.map((value) => value.toString()).join('\n');
}

void handleNofication() {
  OneSignal.Notifications.addClickListener((event) {
    event.result;
    Get.to(SettingScreen());
  });
  // OneSignal.shared.setNotificationOpenedHandler((result) {
  //   // Custom logic upon opening a notification
  // });
}

num roundUpToTwoDecimalPlaces(double value) {
  return (value * 100).ceil() / 100;
}

num roundDownToHundred(num value) {
  return (value ~/ 100) * 100;
}

// Function to validate password strength
bool _isPasswordStrong(String password) {
  // Regex to check for at least one uppercase, one lowercase, one number, and one special character
  final regex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$');

  return regex.hasMatch(password);
}

Future<void> unsubscribeUser(String externalId) async {
  // Replace with your OneSignal App ID and REST API Key
  final String oneSignalAppId = dotenv.get('SIGNAL_APP_ID');
  final String restApiKey = dotenv.get('RESTAPIKEY');

  // OneSignal API endpoint
  final String apiUrl = 'https://api.onesignal.com/players/$externalId';

  // Headers for the API request
  final Map<String, String> headers = {
    'Authorization': 'Basic $restApiKey',
    'Content-Type': 'application/json',
  };

  // Body for the API request
  final Map<String, dynamic> body = {
    'app_id': oneSignalAppId,
    'identifier': externalId,
    'subscription': {'opted_in': false}, // Unsubscribe the user
  };

  try {
    // Send the PUT request to update the user's subscription status
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(body),
    );

    // Check the response status
    if (response.statusCode == 200) {
      print('User unsubscribed successfully');
    } else {
      print('Failed to unsubscribe user: ${response.body}');
    }
  } catch (e) {
    print('Error unsubscribing user: $e');
  }
}

String cleanPhoneNumber(String phoneNumber,
    {String defaultCountryCode = "+221"}) {
  // Remove all spaces
  String cleanedNumber = phoneNumber.replaceAll(" ", "").replaceAll("-", "");

  // Remove the country code if it exists
  if (cleanedNumber.startsWith(defaultCountryCode)) {
    cleanedNumber = cleanedNumber.substring(defaultCountryCode.length);
  }

  return cleanedNumber;
}

bool validatePhoneNumber(String phoneNumber, {int expectedLength = 9}) {
  // Ensure the number contains only digits
  if (!RegExp(r"^\d+$").hasMatch(phoneNumber)) {
    return false;
  }

  // Validate length
  return phoneNumber.length == expectedLength;
}


bool isValidCountryPrefixNumber(String input, List<String> validPrefixes,
    {int minLength = 0}) {
  if (input.isEmpty) return false;

  // Clean the input by removing non-digit characters
  String cleanedInput = input.replaceAll(RegExp(r'[^0-9]'), '');

  // Check minimum length if specified
  if (minLength > 0 && cleanedInput.length < minLength) {
    return false;
  }

  // If no prefixes are provided, validate all non-empty numbers
  if (validPrefixes.isEmpty) {
    return cleanedInput.isNotEmpty;
  }

  // Otherwise check against valid prefixes
  for (String prefix in validPrefixes) {
    if (cleanedInput.startsWith(prefix)) {
      return true;
    }
  }

  return false;
}
