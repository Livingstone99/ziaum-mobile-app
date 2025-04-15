import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:switch_app/models/countryModel.dart';
import 'package:switch_app/models/currencyModel.dart';
import 'package:switch_app/models/responseModel/configResponseModel.dart';
import 'package:switch_app/providers/authProvider.dart';

import 'package:switch_app/services/configservice.dart';


import '../widgets/customSnackbar.dart';

class ConfigNotifier extends StateNotifier<ConfigResponseModel> {
  Ref ref;
  ConfigNotifier(this.ref) : super(ConfigResponseModel());

  void instantiateAuth() {
    state = state.copyWith(
      // merchantCategory: [],
      loading: false,
    );
  }

  Future<void> getAllCountry() async {
    state = state.copyWith(loading: true);
    final response = await ConfigService().getAlCountry();
    if (response.statusCode == 200) {
      print(response);

      List<CountryModel> _allCountries = [];
      for (var item in response.data) {
        _allCountries.add(CountryModel.fromJson(item));
      }
      ref.read(allCountryListProvider.notifier).state = _allCountries;
      ref.read(selectedCountryProvider.notifier).state =
          _allCountries.firstWhere((element) => element.countryCode == "+41");
      state = state.copyWith(loading: false);
    } else {
      if (response.statusCode == 401) {
        ref.read(AuthProvider.notifier).logoutUser();
      }
      state = state.copyWith(loading: false);
      CustomSnackbar.showSnackbar(
          title: "Erreur", message: response.statusMessage, seconds: 5);
    }
  }

  Future<void> getLatestCurrency(int currencyId) async {
    state = state.copyWith(loading: true);
    final response = await ConfigService().getLatestCurrency(currencyId);
    if (response.statusCode == 200) {
      print(response);

      Currency currency = Currency();
      currency = Currency.fromJson(response.data);

      ref.read(selectedCurrencyProvider.notifier).state = currency;
      state = state.copyWith(loading: false);
    } else {
      if (response.statusCode == 401) {
                ref.read(AuthProvider.notifier).logoutUser();
      }
      state = state.copyWith(loading: false);
      CustomSnackbar.showSnackbar(
          title: "Erreur", message: response.statusMessage, seconds: 5);
    }
  }

  Future<void> getLatestConfig(int configId) async {
    state = state.copyWith(loading: true);
    final response = await ConfigService().getLatestConfig(configId);
    if (response.statusCode == 200) {
      print(response);

      CountryModel countryModel = CountryModel();
      countryModel = CountryModel.fromJson(response.data);

      ref.read(selectedCountryProvider.notifier).state = countryModel;
      state = state.copyWith(loading: false);
    } else {
      if (response.statusCode == 401) {
                ref.read(AuthProvider.notifier).logoutUser();
      }
      state = state.copyWith(loading: false);
      CustomSnackbar.showSnackbar(
          title: "Erreur", message: response.statusMessage, seconds: 5);
    }
  }

  Future<void> getAllOperator() async {
    state = state.copyWith(loading: true);
    final response = await ConfigService().getAllOperators();
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
      if (response.statusCode == 401) {
                ref.read(AuthProvider.notifier).logoutUser();
      }
      state = state.copyWith(loading: false);
      CustomSnackbar.showSnackbar(
          title: "Erreur", message: response.statusMessage, seconds: 5);
    }
  }
}

final ConfigProvider =
    StateNotifierProvider<ConfigNotifier, ConfigResponseModel>((ref) {
  return ConfigNotifier(ref);
});

final allCountryListProvider = StateProvider<List<CountryModel>>((ref) {
  return [];
});
final allOperatorProvider = StateProvider<List<OperatorModel>>((ref) {
  return [];
});
final selectedCountryProvider = StateProvider<CountryModel>((ref) {
  return CountryModel(
      image: "https://backend.ziaum.com/media/country_flag/swiss.jpeg",
      countryName: "Swiss",
      countryCode: "+41");
});
final selectedOperatorProvider = StateProvider<OperatorModel>((ref) {
  return OperatorModel();
});
final selectedCurrencyProvider = StateProvider<Currency>((ref) {
  return Currency();
});
final selectedtransactionCountryProvider = StateProvider<CountryModel>((ref) {
  return CountryModel(
      image:
          "https://focus-bucket-upload.s3.amazonaws.com/files/bd346d99-be65-4394-9fb6-d45dae6a1e80",
      countryCode: "+14");
});
