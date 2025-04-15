class SelectedContactModel {
  String? name;
  String? phoneNumber;
  String? logo;
  bool? isMerchant;

  SelectedContactModel(
      {this.name, this.isMerchant, this.logo, this.phoneNumber});

  SelectedContactModel.fromJson(Map json) {
    name = json['name'] ?? "Anonymous";
    phoneNumber = json["phoneNumber"];
    logo = json["logo"];
    isMerchant = json["isMerchant"];
  }
}
