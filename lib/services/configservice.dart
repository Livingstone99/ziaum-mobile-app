import 'package:dio/dio.dart';
import 'package:switch_app/constants/api.dart';

import 'shared_preference.dart';

class ConfigService {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      baseUrl: serverAddress,
      headers: {
        // 'Content-Type': "application/x-www-form-urlencoded",
        "authorization": Preference().token,
        "app-key": "frontend-key"
      },
    ),
  );

  Future<Response> getAlCountry() async {
    try {
      var response = await dio.get(
        "configuration/country-configs/",
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

  Future<Response> getLatestCurrency(int currency) async {
    try {
      var response = await dio.get(
        "currency/currencies/${currency}",
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

  Future<Response> getLatestConfig(int countryId) async {
    try {
      var response = await dio.get(
        "configuration/country-configs/${countryId}",
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

  Future<Response> getAllOperators() async {
    try {
      var response = await dio.get(
        "configuration/operators/",
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
