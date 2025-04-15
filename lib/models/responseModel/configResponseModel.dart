

import '../countryModel.dart';

class ConfigResponseModel {
  // late List<BannerModel>? ads;
  late CountryModel? countryModel;
  late bool loading;

  late bool showDialog;
  late List<CountryModel>? allCountries;

  ConfigResponseModel(
      {
        // this.ads,
      this.loading = false,
      this.showDialog = false,
      this.countryModel,
      this.allCountries});
  ConfigResponseModel.fromJson(Map<String, dynamic> json) {
    // ads = json["ads"];

    loading = json['loading'];
    showDialog = json['show_dialog'] ?? false;
    allCountries = json["allCountries"] ?? [];
  }
  ConfigResponseModel copyWith(
      {
        // List<BannerModel>? ads,
      bool? loading,
      List<CountryModel>? allCountries,
      bool? showDialog,
      String? imgUpload}) {
    return ConfigResponseModel(
      // ads: ads ?? this.ads,
      loading: loading ?? this.loading,
      allCountries: allCountries ?? this.allCountries,
      showDialog: showDialog ?? this.showDialog,
    );
  }
}
