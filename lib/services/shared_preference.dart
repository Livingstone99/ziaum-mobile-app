import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static SharedPreferences? sharedPreferences;

  init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    //debugPrint("the logg state $loggedIn");
  }

  String get token => sharedPreferences!.getString("token") ?? " ";
  String get contactUs => sharedPreferences!.getString("contactUs") ?? " ";
  String get otpToken => sharedPreferences!.getString("otpToken") ?? " ";
  String get phoneNumber => sharedPreferences!.getString("phoneNumber") ?? "";
  String get email => sharedPreferences!.getString("email") ?? "";
  String get countryId => sharedPreferences!.getString("country_id") ?? " ";
  String get countryCode =>
      sharedPreferences!.getString("country_code") ?? "+226";

  String get selectedLang =>
      sharedPreferences!.getString("selectedLang") ?? "fr";
  bool get loggedIn => sharedPreferences!.getBool("loggedIn") ?? false;
  bool get createdAccount => sharedPreferences!.getBool("createdAccount") ?? false;
  bool get enableDeviceBiometrics =>
      sharedPreferences!.getBool("biometrics") ?? false;

  bool get firstTime => sharedPreferences!.getBool("firstTime") ?? true;
  bool get emailVerified =>
      sharedPreferences!.getBool("emailVerified") ?? false;

  String get  firstname => sharedPreferences!.getString("firstname") ?? "";
  String get userId => sharedPreferences!.getString("userId") ?? "";

  String get deviceToken => sharedPreferences!.getString("deviceToken") ?? "";

  set token(String value) {
    sharedPreferences!.setString("token", value);
  }

  set otpToken(String value) {
    sharedPreferences!.setString("otpToken", value);
  }

  set countryCode(String value) {
    sharedPreferences!.setString("country_code", value);
  }

  set enableBiometrics(bool value) {
    sharedPreferences!.setBool("biometrics", value);
  }

  set contactUs(String value) {
    sharedPreferences!.setString("contactUs", value);
  }

  set phoneNumber(String value) {
    sharedPreferences!.setString("phoneNumber", value);
  }

  set email(String value) {
    sharedPreferences!.setString("email", value);
  }

  set countryId(String value) {
    sharedPreferences!.setString("country_id", value);
  }

  set loggedIn(bool value) {
    sharedPreferences!.setBool("loggedIn", value);
  }

  set createdAccount(bool value) {
    sharedPreferences!.setBool("createdAccount", value);
  }

  set firstTime(bool value) {
    sharedPreferences!.setBool("firstTime", value);
  }

  set emailVerified(bool value) {
    sharedPreferences!.setBool("emailVerified", value);
  }

  set setUserId(String value) {
    sharedPreferences!.setString("userId", value);
  }

  set setDeviceToken(String value) {
    sharedPreferences!.setString("deviceToken", value);
  }

  Map getUserData() {
    var data = sharedPreferences!.getString("userData");
    return json.decode(data!);
  }

  void setUserData(Map data) {
    sharedPreferences!.setString("userData", json.encode(data));
  }

  void clear() {
    sharedPreferences!.clear();
  }
}

final sharedPrefs = Preference();
