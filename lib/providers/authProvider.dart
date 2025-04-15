import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get/get.dart' as Get_Navigator;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:switch_app/models/bannerModel.dart';
import 'package:switch_app/models/countryModel.dart';
import 'package:switch_app/providers/configProvider.dart';
import 'package:switch_app/screens/auth/kycScreen.dart';
import 'package:switch_app/screens/auth/loginScreen.dart';
import 'package:switch_app/screens/auth/signupScreen.dart';
import 'package:switch_app/screens/auth/waitingScreen.dart';
import 'package:switch_app/screens/home/homeScreen.dart';

import '../models/responseModel/authResponseModel.dart';

import '../models/selectedContactModel.dart';
import '../models/userModel.dart';
import '../screens/auth/authscreen.dart';
import '../screens/auth/updatePasswordScreen.dart';
import '../services/authService.dart';
import '../services/shared_preference.dart';
import '../utils/utils.dart';
import '../utils/voidFunctions.dart';
import '../widgets/customSnackbar.dart';
// import 'package:dio/dio.dart';

class AuthNotifier extends StateNotifier<AuthResponse> {
  Ref ref;
  AuthNotifier(this.ref) : super(AuthResponse());

  void instantiateAuth() {
    state = state.copyWith(
      merchants: [],
      // merchantCategory: [],
      loading: false,
    );
  }

  Future<bool> sendOtp(String email, {String reason = ""}) async {
    state = state.copyWith(loading: true);
    final response = await AuthService().sendOtp(email, reason);
    if (response.statusCode == 200) {
      print(response);

      // if (response["data"]["status"] == 200) {
      //   state = state.copyWith(otpsent: true, loading: false);
      //   print(response);
      //   var data = response["data"]["token"];
      //   // print(data);
      //   // Preference().otpToken = data;
      //   // // navigateToPage(const VerifyOtpScreen());
      // } else {
      state = state.copyWith(otpsent: false, loading: false);

      //   showAlertDialog(title: "Error", message: response["data"]);
      // }
      return false;
    } else {
      state = state.copyWith(otpsent: false, loading: false);

      CustomSnackbar.showSnackbar(
          title: response.statusMessage,
          message: responseToString(response.data),
          seconds: 5);

      return true;
    }
  }

  Future<void> createAccount(Map data) async {
    state = state.copyWith(loading: true);
    final response = await AuthService().createAccount(data);
    print(response);
    if (response.statusCode == 201) {
      state = state.copyWith(otpsent: true, loading: false);
      print(response);
      var data = response.data;
      // print(data);
      // print(data["_id"]);

      ref.read(userModelProvider.notifier).state =
          UserModel.fromJson(data["user"]);

      Preference().createdAccount = true;
      Preference().token = data["token"];
      Preference().setUserId = data["user"]["id"];
      Get_Navigator.Get.offAll(KycScreen());
      // navigateToPage(const HomeScreen(),
      //     navigationType: NavigationType.replaceAll);
      // Preference().otpToken = data;
      // navigateToPage(const VerifyOtpScreen());
    } else {
      state = state.copyWith(otpsent: false, loading: false);
      print(response);
      showAlertDialog(title: "Error", message: response.statusMessage);
    }
  }

  Future<void> login(Map data) async {
    state = state.copyWith(loading: true);
    final response = await AuthService().login(data);

    if (response.statusCode == 200) {
      state = state.copyWith(loading: false);

      print(response);
      var data = response.data;
      if (data["user"]["is_superuser"] || data["user"]["is_staff"]) {
        CustomSnackbar.showSnackbar(
            title: "Error", message: "Super admin or staff not allowed");
        return;
      }
      // print(data);
      // print(data["_id"]);

      ref.read(userModelProvider.notifier).state =
          UserModel.fromJson(data["user"]);

      Preference().createdAccount = true;
      Preference().token = data["token"];
      Preference().setUserId = data["user"]["id"];
      print("country details ");
      print(data["user"]["country"]);
      ref.read(selectedCountryProvider.notifier).state =
          CountryModel.fromJson(data["user"]["country"]);

      // navigateToPage(const HomeScreen(),
      //     navigationType: NavigationType.replaceAll);
      // Preference().otpToken = data;
      // navigateToPage(const VerifyOtpScreen());
      if (data["user"]["kyc_verified"] == false) {
        Get_Navigator.Get.to(KycScreen());
        return;
      }
      Get_Navigator.Get.offAll(WaitingScreen());
    } else {
      state = state.copyWith(otpsent: false, loading: false);

      CustomSnackbar.showSnackbar(
          title: "Error", message: responseToString(response.data));
    }
  }

  Future<void> updateUser(Map<String, dynamic> datas) async {
    state = state.copyWith(loading: true, showDialog: false);
    final response = await AuthService().updateUser(datas);
    print("response update");
    print(response);
    if (response.statusCode == 200) {
      // Map<String, dynamic> data = response["data"]["user"];

      ref.read(userModelProvider.notifier).state =
          UserModel.fromJson(response.data);
      state = state.copyWith(loading: false);
    } else {
      state = state.copyWith(
        showDialog: true,
        loading: false,
      );
      CustomSnackbar.showSnackbar(
          title: "Error", message: response.statusMessage, seconds: 5);
    }
  }

  Future<void> DocumentUpload(Map<String, dynamic> datas) async {
    state = state.copyWith(loading: true, showDialog: false);
    Map<String, dynamic> completeData = {};
    FormData formData = FormData();
    print(ref.read(selectedDocProvider));
    if (ref.read(selectedDocProvider) != "Passport") {
      completeData = {
        ...datas,
        "document_front": ref.read(selectedDocFrontProvider),
        "document_back": ref.read(selectedDocBackProvider),
        "residential_document": ref.read(selectedResidenceDocProvider),
      };
      formData = FormData.fromMap({
        ...completeData, // Include other user completeData
        "document_front": await MultipartFile.fromFile(
            completeData["document_front"],
            filename: "document_front.jpg"),
        "document_back": await MultipartFile.fromFile(
            completeData["document_back"],
            filename: "document_back.jpg"),
        "residential_document": await MultipartFile.fromFile(
            completeData["residential_document"],
            filename: "residential.jpg"),
      });
    } else {
      print("this is the document path");
      print(ref.read(selectedDocFrontProvider));
      completeData = {
        ...datas,
        "document_front": ref.read(selectedDocFrontProvider),
        "residential_document": ref.read(selectedResidenceDocProvider),
      };

      formData = FormData.fromMap({
        ...completeData, // Include other user completeData
        "document_front": await MultipartFile.fromFile(
            completeData["document_front"],
            filename: "document_front.jpg"),

        "residential_document": await MultipartFile.fromFile(
            completeData["residential_document"],
            filename: "residential.jpg"),
      });
    }

    final response = await AuthService().uploadDocuments(formData);
    print(response);
    if (response.statusCode == 200) {
      ref.read(userModelProvider.notifier).state =
          UserModel.fromJson(response.data);
      Get_Navigator.Get.offAll(WaitingScreen());

      state = state.copyWith(loading: false);
    } else {
      state = state.copyWith(showDialog: true, loading: false);
      CustomSnackbar.showSnackbar(
          title: "Error",
          message: response.statusMessage ?? "Update failed",
          seconds: 5);
    }
  }

  Future<void> updatePassword(String newpassword) async {
    state = state.copyWith(loading: true, showDialog: false);
    final response = await AuthService().updatePassword(newpassword);
    print("response update");
    print(response);
    if (response.statusCode == 200) {
      state = state.copyWith(loading: false);
      CustomSnackbar.showSnackbar(
          title: "Error", message: response.data["message"], seconds: 5);
      Get_Navigator.Get.offAll(LoginScreen());
    } else {
      state = state.copyWith(
        showDialog: true,
        loading: false,
      );
      CustomSnackbar.showSnackbar(
          title: "Error", message: response.statusMessage, seconds: 5);
    }
  }

  Future<void> changePassword(String newpassword, String oldPassword) async {
    state = state.copyWith(loading: true, showDialog: false);
    final response =
        await AuthService().changePassword(newpassword, oldPassword);
    print("response update");
    print(response);
    if (response.statusCode == 200) {
      state = state.copyWith(loading: false);
      CustomSnackbar.showSnackbar(
          title: "Error", message: response.data["message"], seconds: 5);
      Get_Navigator.Get.offAll(HomeScreen());
    } else {
      state = state.copyWith(
        showDialog: true,
        loading: false,
      );
      CustomSnackbar.showSnackbar(
          title: "Error", message: response.statusMessage, seconds: 5);
    }
  }

  Future<void> verifyOtp(String code, {String reason = ""}) async {
    print("reason in provider $reason");
    state = state.copyWith(loading: true);
    final response = await AuthService().verifyOtp(code, reason: reason);
    if (response.statusCode == 200) {
      print(response);

      Preference().emailVerified = true;

      state = state.copyWith(otpsent: true, loading: false);
      // print(response);
      //
      if (reason == "forget_password") {
        Get_Navigator.Get.off(UpdatePasswordScreen());
        return;
      }
      Get_Navigator.Get.off(SignupScreen());
    } else {
      state = state.copyWith(otpsent: false, loading: false);
      CustomSnackbar.showSnackbar(
          title: response.statusMessage,
          message: responseToString(response.data),
          seconds: 5);
    }
  }

  Future<void> unLockAccount(String code) async {
    state = state.copyWith(loading: true);
    final response = await AuthService().unLockScreen(code);
    if (!response["error"]) {
      print(response);

      state = state.copyWith(otpsent: true, loading: false);
      print(response);

      var data = json.decode(decryptAESCryptoJS(response["data"]["merchant"]));
      ref.read(userModelProvider.notifier).state = UserModel.fromJson(data);
      Preference().loggedIn = true;
      Preference().token = data["refresh_token"];
      Preference().setUserId = data["_id"];
      // navigateToPage(const HomeScreen(),
      //     navigationType: NavigationType.replaceAll);
    } else {
      state = state.copyWith(otpsent: false, loading: false);
      CustomSnackbar.showSnackbar(
          title: "Erreur", message: response["data"]["message"], seconds: 5);
    }
  }

  Future<void> getAllNotification() async {
    state = state.copyWith(loading: true);
    final response = await AuthService().getAllNotifcation();
    if (response.statusCode == 200) {
      print(response);

      List<OperatorModel> _allOperator = [];
      for (var item in response.data) {
        _allOperator.add(OperatorModel.fromJson(item));
      }
      print("operator length");
      print(_allOperator.length);
      ref.read(allOperatorProvider.notifier).state = _allOperator;
      state = state.copyWith(loading: false);
    } else {
      state = state.copyWith(loading: false);
      CustomSnackbar.showSnackbar(
          title: "Erreur", message: response.statusMessage, seconds: 5);
    }
  }

  Future<void> getUser() async {
    state = state.copyWith(loading: true);
    final response = await AuthService().getUserById(Preference().userId);
    print(response);
    if (response.statusCode == 200) {
      print(response);

      state = state.copyWith(otpsent: true, loading: false);
      print(response);
      Map<String, dynamic> data = response.data;
      ref.read(userModelProvider.notifier).state =
          UserModel.fromJson(data["user"]);
      Preference().loggedIn = true;
      Preference().token = data["token"];
      Preference().setUserId = data["user"]["id"];
      ref.read(selectedCountryProvider.notifier).state =
          CountryModel.fromJson(data["user"]["country"]);
      // navigateToPage(const HomeScreen(),
      //     navigationType: NavigationType.replaceAll);
    } else {
      if (response.statusCode == 401 || response.statusCode == 403) {
        logoutUser();
      }
      state = state.copyWith(otpsent: false, loading: false);
      CustomSnackbar.showSnackbar(
          title: "Erreur", message: response.statusMessage, seconds: 5);
    }
  }

  Future<void> getLocalContact() async {
    List<Contact> contacts = [];
    List<Contact> filterList = [];
    if (await FlutterContacts.requestPermission(readonly: true)) {
      contacts = await FlutterContacts.getContacts(withProperties: true);
      for (var contact in contacts) {
        if (contact.phones.isNotEmpty) {
          filterList.add(contact);
        }
      }

      ref.read(contactProvider.notifier).state = filterList;
    }
  }

  Future<void> logoutUser() async {
    // Clear user preferences
    Preference().clear();
    // var providers = ref.container.getAllProviderElements();
    // for (var element in providers) {
    //   element.invalidateSelf();
    // }

    // Logout from OneSignal
    await OneSignal.logout();
    Get_Navigator.Get.offAll(AuthScreen());
  }
}

final AuthProvider = StateNotifierProvider<AuthNotifier, AuthResponse>((ref) {
  return AuthNotifier(ref);
});

// Notifier for filtered contacts
class FilteredContactsNotifier extends StateNotifier<List<Contact>> {
  final List<Contact> allContacts;

  FilteredContactsNotifier(this.allContacts) : super(allContacts);

  void filterContacts(String query) {
    if (query.isEmpty) {
      state = allContacts;
    } else {
      state = allContacts
          .where((contact) =>
              contact.displayName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void resetContacts() {
    state = allContacts;
  }
}

// Provider for filtering logic
final filteredContactsProvider =
    StateNotifierProvider<FilteredContactsNotifier, List<Contact>>((ref) {
  final contacts = ref.watch(contactProvider);
  return FilteredContactsNotifier(contacts);
});

final userModelProvider = StateProvider<UserModel>((ref) {
  return UserModel();
});
final contactProvider = StateProvider<List<Contact>>((ref) {
  return [];
});

final selectedContactProvider = StateProvider<SelectedContactModel>((ref) {
  return SelectedContactModel();
});
final homeMerchantProvider = StateProvider<List<UserModel>>((ref) {
  return [];
});
final bannerListProvider = StateProvider<List<BannerModel>>((ref) {
  return [BannerModel(cover: "")];
});
final createAccountData = StateProvider<Map>((ref) {
  return {};
});
final beforeAccountData = StateProvider<Map>((ref) {
  return {};
});
final selectedDocProvider = StateProvider<String>((ref) {
  return "";
});
final selectedDocFrontProvider = StateProvider<String>((ref) {
  return "";
});
final selectedDocBackProvider = StateProvider<String>((ref) {
  return "";
});
final selectedResidenceDocProvider = StateProvider<String>((ref) {
  return "";
});
