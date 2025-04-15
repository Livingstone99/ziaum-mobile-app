import 'package:dio/dio.dart';
import 'package:switch_app/constants/api.dart';

import 'shared_preference.dart';

class TransactionService {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      baseUrl: serverAddress,
      headers: {
        // 'Content-Type': "application/x-www-form-urlencoded",
        "authorization": "Token ${Preference().token}",
        "app-key": "frontend-key"
      },
    ),
  );

  Future<Response> createPaymentIntent(Map data) async {
    try {
      var response = await dio.post(
        "transaction/stripe-intent",
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
  // Future<Response> getTransactionById(String transactionId) async {
  //   try {
  //     var response = await dio.get(
  //       "transaction/${transactionId}",

  //       options: Options(
  //         method: "GET",
  //         followRedirects: true,
  //         contentType: Headers.jsonContentType,
  //       ),
  //     );
  //     //debugPrint(response.data);
  //     return response;
  //   } on DioException catch (e) {
  //     //debugPrint(e.toString());
  //     return e.response!;
  //   }
  // }

  Future<Response> initiateTransaction(Map data) async {
    try {
      var response = await dio.post(
        "transaction/",
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

  Future<Response> getAllOperators() async {
    try {
      var response = await dio.get(
        "configuration/operators",
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

  Future<Response> getUserTransactions() async {
    try {
      var response = await dio.get(
        "transaction/user-transactions",
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

  Future<Response> getUserHomeTransactions() async {
    try {
      var response = await dio.get(
        "transaction/user-home-transactions",
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

  Future<Response> getByDateTransactions(Map<String, dynamic> data) async {
    try {
      var response = await dio.get(
        "transaction/fetch-by-date-transactions",
        queryParameters: data,
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

  Future<Response> checkTransactionStatus(Map data) async {
    try {
      var response = await dio.post(
        "transaction/paydunya/check-disbursement-status",
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

  Future<Response> getTransactiondetails(String transactionId) async {
    try {
      var response = await dio.get(
        "transaction/${transactionId}",
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
}
