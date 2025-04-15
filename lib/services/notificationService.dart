import 'package:dio/dio.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api.dart';
import 'shared_preference.dart';

class NotificationService {
  late SharedPreferences _pref;

  // dio instance

  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      baseUrl: serverAddress,
      headers: {
        // 'Content-Type': "application/x-www-form-urlencoded",
        "Authorization": "Token ${Preference().token}",
        "app-key": "frontend-key"
      },
    ),
  );

  Future<Response> getAllNotifcation() async {
    print(Preference().userId);
    print(Preference().token);
    try {
      var response = await dio.get(
        "notification",
        options: Options(
          method: "GET",
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

  Future<Response> verifyOtp(
    String? code,
  ) async {
    try {
      var response = await dio.post(
        "user/verify-otp",
        data: {"otp": code, "email": Preference().email},
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
  Future getUserById(String? id) async {
    //debugPrint(id);
    print("object is here : $id");
    print("object is here : ${Preference().token}");
    try {
      var response = await dio.get(
        "v2-1/merchant/get-one-mobile/$id",
        options: Options(
          method: "GET",
          followRedirects: true,
          contentType: Headers.jsonContentType,
          headers: {
            "authorization": Preference().token,
          },
        ),
      );
      //debugPrint(response.data);
      return {"error": false, "data": response.data};
    } on DioException catch (e) {
      return {"error": true, "data": e.response!.data};
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

  Future updateUser(Map? data) async {
    // //debugPrint("this is the response from update user $data");
    try {
      var response = await dio.put(
        "v2-1/merchant/update-merchant/${Preference().userId}",
        data: data,
        options: Options(
          method: "PUT",
          followRedirects: true,
          contentType: Headers.jsonContentType,
          headers: {
            "authorization": Preference().token,
          },
        ),
      );
      //debugPrint("from service ${response.data}");
      return {"error": false, "data": response.data};
    } on DioException catch (e) {
      //debugPrint("from service ${e.message}");

      return {"error": true, "data": e.response!.data};
    }
  }
}
