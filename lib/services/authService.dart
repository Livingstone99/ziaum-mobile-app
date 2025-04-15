import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api.dart';
import 'shared_preference.dart';

class AuthService {
  late SharedPreferences _pref;
  getUserToken() async {
    _pref = await SharedPreferences.getInstance();
    var token = _pref.getString('token') ?? "";
    return token;
  }

  // dio instance
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      baseUrl: serverAddress,
      headers: {
        'Content-Type': "application/x-www-form-urlencoded",
        "authorization": "Token ${Preference().token}",
        "app-key": "frontend-key"
      },
    ),
  );
  final Dio dio2 = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      baseUrl: serverAddress,
      headers: {
        'Content-Type': "application/x-www-form-urlencoded",
        // "authorization": "",
        "app-key": "frontend-key"

      },
    ),
  );

  Future pinValidation(String? pin) async {
    var token = await getUserToken();
    try {
      var response = await dio.post(
        'v2-1/merchant/unlock-screen-merchant/${Preference().userId}',
        data: {
          'pin': pin,
        },
        options: Options(
          headers: {
            'authorization': token,
          },
        ),
      );
      return {"error": false, "data": response.data};
    } on DioException catch (e) {
      //debugPrint(e.message);
      return {"error": true, "message": e.message};
    }
  }

  // Future checkNumber(String? number) async {
  //   try {
  //     var response = await dio.get(
  //       "v2/merchant/get-by-number/$number",
  //       options: Options(
  //         method: "GET",
  //         followRedirects: true,
  //         contentType: Headers.jsonContentType,
  //       ),
  //     );
  //     //debugPrint(response.data);
  //     return {"error": false, "data": response.data};
  //   } on DioException catch (e) {
  //     //debugPrint(e.toString());
  //     return {"error": true, "data": e.message};
  //   }
  // }

  Future<Response> createAccount(Map data) async {
    try {
      print("data to send");
      print(data);
      var response = await dio2.post(
        "user/signup",
        data: data,
        options: Options(
          method: "POST",
          followRedirects: true,
          contentType: Headers.jsonContentType,
        ),
      );
      //debugPrint(response.data);
      return response;
    } on DioException catch (e) {
      //debugPrint(e.toString());
      return e.response!;
    }
  }

  Future<Response> login(Map data) async {
    try {
      final Response response = await dio.post(
        "user/login",
        data: data,
        options: Options(
          method: "POST",
          followRedirects: true,
          contentType: Headers.jsonContentType,
        ),
      );
      //debugPrint(response.data);
      return response;
    } on DioException catch (e) {
      //debugPrint(e.toString());
      return e.response!;
    }
  }

  Future<Response> updateUser(Map data) async {
    print("data patch");
    print(data);
    try {
      final Response response = await dio.patch(
        "user/update/${Preference().userId}",
        data: data,
        options: Options(
          method: "PATCH",
          followRedirects: true,
          contentType: Headers.jsonContentType,
        ),
      );
      //debugPrint(response.data);
      return response;
    } on DioException catch (e) {
      //debugPrint(e.toString());
      return e.response!;
    }
  }

Future<Response> uploadDocuments(
      FormData data) async {
    try {
      // Create FormData to send images and other data
      
      // FormData formData = FormData.fromMap({
      //   ...data, // Include other user data
      //   "document_front": await MultipartFile.fromFile(data["document_front"],
      //       filename: "document_front"),
      //   "document_back": await MultipartFile.fromFile(data["document_back"],
      //       filename: "document_back"),
      // });

      final Response response = await dio2.patch(
        "user/kyc-update/${Preference().userId}",
        data: data,
        options: Options(
          method: "PATCH",
          followRedirects: true,
          contentType: Headers
              .multipartFormDataContentType, // Important for file uploads
        ),
      );

      return response;
    } on DioException catch (e) {
      return e.response!;
    }
  }
  Future<Response> sendOtp(String email, String reason) async {
    try {
      var response = await dio.post(
        "user/send-otp",
        data: {"email": email, "reason": reason},
        options: Options(
          method: "POST",
          followRedirects: true,
          contentType: Headers.jsonContentType,
        ),
      );
      // debugPrint(response.data);
      return response;
    } on DioException catch (e) {
      //debugPrint(e.toString());
      return e.response!;
    }
  }

  Future unLockScreen(String code) async {
    print(Preference().userId);
    try {
      var response = await dio.post(
        "v2-1/merchant/unlock-screen-merchant-mobile/${Preference().userId}",
        data: {
          "pin": code,
        },
        options: Options(
          method: "POST",
          followRedirects: true,
          contentType: Headers.jsonContentType,
        ),
      );
      //debugPrint(response.data);
      return {"error": false, "data": response.data};
    } on DioException catch (e) {
      //debugPrint(e.toString());
      return {"error": true, "data": e.response!.data};
    }
  }

  Future localAuthVerification() async {
    print(Preference().userId);
    try {
      var response = await dio.get(
        "v2-1/merchant/unlock-face-merchant-mobile/${Preference().userId}",
        options: Options(
          method: "GET",
          followRedirects: true,
          contentType: Headers.jsonContentType,
        ),
      );
      //debugPrint(response.data);
      return {"error": false, "data": response.data};
    } on DioException catch (e) {
      //debugPrint(e.toString());
      return {"error": true, "data": e.message};
    }
  }

  Future getAllNotifcation() async {
    print(Preference().userId);
    try {
      var response = await dio.get(
        "v2-1/merchant/unlock-face-merchant-mobile/${Preference().userId}",
        options: Options(
          method: "GET",
          followRedirects: true,
          contentType: Headers.jsonContentType,
        ),
      );
      //debugPrint(response.data);
      return {"error": false, "data": response.data};
    } on DioException catch (e) {
      //debugPrint(e.toString());
      return {"error": true, "data": e.message};
    }
  }

  Future<Response> verifyOtp(String? code, {String reason = ""}) async {
    try {
      print("reason in service $reason");

      var response = await dio.post(
        "user/verify-otp",
        data: {"otp": code, "email": Preference().email, "reason": reason},
        options: Options(
          method: "POST",
          followRedirects: true,
          contentType: Headers.jsonContentType,
        ),
      );
      //debugPrint(response.data);
      print(response);
      return response;
    } on DioException catch (e) {
      //debugPrint(e.toString());
      print(e.response!.data);

      return e.response!;
    }
  }

  Future<Response> updatePassword(String? newPassword) async {
    try {
      var response = await dio.post(
        "user/reset-password",
        data: {"email": Preference().email, "new_password": newPassword},
        options: Options(
          method: "POST",
          followRedirects: true,
          contentType: Headers.jsonContentType,
        ),
      );
      //debugPrint(response.data);
      print(response);
      return response;
    } on DioException catch (e) {
      //debugPrint(e.toString());
      print(e.response!.data);

      return e.response!;
    }
  }

  Future<Response> changePassword(
      String? newPassword, String? oldPassword) async {
    try {
      var response = await dio.post(
        "user/change-password",
        data: {"old_password": oldPassword, "new_password": newPassword},
        options: Options(
          method: "POST",
          followRedirects: true,
          contentType: Headers.jsonContentType,
        ),
      );
      //debugPrint(response.data);
      print(response);
      return response;
    } on DioException catch (e) {
      //debugPrint(e.toString());
      print(e.response!.data);

      return e.response!;
    }
  }

  Future uploadFile({@required String? img64}) async {
    try {
      var response = await dio.post(
        "v5/upload/create-url-mobile",
        data: {
          "file": img64,
        },
        options: Options(
          method: "PUT",
          // followRedirects: true,
          contentType: Headers.jsonContentType,
        ),
      );
      //debugPrint("here is upload response");
      //debugPrint(response.data);
      return {"error": false, "data": response.data};
    } on DioException catch (e) {
      return {"error": true, "data": e.message};
    }
  }

//get user by id
  Future<Response> getUserById(String? id) async {
    //debugPrint(id);
    print("object is here : $id");
    print("object is here : ${Preference().token}");
    try {
      var response = await dio.get(
        "user/$id",
        options: Options(
          method: "GET",
          followRedirects: true,
          contentType: Headers.jsonContentType,
        ),
      );
      //debugPrint(response.data);
      return response;
    } on DioException catch (e) {
      return e.response!;
    }
  }

  Future fetchUserAfterScan(String? userNumber) async {
    //debugPrint(id);
    try {
      var response = await dio.get(
        "v2-1/merchant/get-scan-merchant/$userNumber",
        options: Options(
          method: "GET",
          followRedirects: true,
          contentType: Headers.jsonContentType,
        ),
      );
      //debugPrint(response.data);
      return {"error": false, "data": response.data};
    } on DioException catch (e) {
      print(e.response);
      return {"error": true, "data": e.response!.data};
    }
  }

  Future getAllCategories() async {
    try {
      var response = await dio.get(
        "v2-1/category/get-all/",
        options: Options(
          method: "GET",
          followRedirects: true,
          contentType: Headers.jsonContentType,
          headers: {
            "authorization": Preference().token,
          },
        ),
      );
      //debugPrint("these are categories");
      //debugPrint(response.data);
      return {"error": false, "data": response.data};
    } on DioException catch (e) {
      return {"error": true, "data": e.message};
    }
  }

  Future getMerchantsByCode() async {
    try {
      var response = await dio.get(
        "v2-1/merchant/get-all-code/+226",
        // "v2/merchant/get-all-code/+226",
        options: Options(
          method: "GET",
          // followRedirects: true,
          contentType: Headers.jsonContentType,
          headers: {
            "authorization": Preference().token,
          },
        ),
      );

      return {"error": false, "data": response.data};
    } on DioException catch (e) {
      //debugPrint(e.toString());
      return {"error": true, "data": e.response!.data};
    }
  }
}
