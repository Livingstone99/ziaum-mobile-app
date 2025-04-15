import 'package:switch_app/constants/api.dart';
import 'package:switch_app/models/currencyModel.dart';

class CountryModel {
  int? id;
  String? image;
  String? countryCode;
  String? countryName;
  Currency? currency;
  List<OperatorModel>? operators;
  num? exchangeRate;
  String? fee;
  num? vatRate;
  bool? enablePaypal;
  bool? enableStripe;
  String? kycRequirements;
  String? reportingRequirement;
  String? paymentMethods;
  String? bankCodes;
  String? countryType;
  String? language;
  String? supportContact;
  String? supportDetail;
  int? phoneNumberLimit;
  num? serviceCharge;
  int? settlementPeriod;
  String? status;
  int? totalReq;
  int? failedReq;
  num? dailyTransactionLimit;
  num? monthlyTransactionLimit;
  num? minTransactionAmount;
  num? maxTransactionAmount;
  List<AdsModel>? ads;
  List<String>? numberPrefixes;

  CountryModel({
    this.image,
    this.id,
    this.countryCode,
    this.countryName,
    this.currency,
    this.fee,
    this.operators,
    this.exchangeRate,
    this.vatRate,
    this.countryType,
    this.kycRequirements,
    this.reportingRequirement,
    this.paymentMethods,
    this.bankCodes,
    this.language,
    this.supportContact,
    this.supportDetail,
    this.phoneNumberLimit,
    this.serviceCharge,
    this.numberPrefixes,
    this.settlementPeriod,
    this.status,
    this.enablePaypal,
    this.enableStripe,
    this.totalReq,
    this.failedReq,
    this.dailyTransactionLimit,
    this.monthlyTransactionLimit,
    this.minTransactionAmount,
    this.maxTransactionAmount,
    this.ads,
  });

  CountryModel.fromJson(Map<String, dynamic> json) {
    List<OperatorModel> opr = [];
    List<AdsModel> ads_pub = [];
    List<String> phone_num_prefix = [];

    if (json["operator"] != [] || json["operator"] != null) {
      for (var operator in json['operator']) {
        opr.add(OperatorModel.fromJson(operator));
      }
    }
    if (json["ads"].isNotEmpty) {
      for (var ads in json['ads']) {
        print("this is from country model");
        print(ads["image"]);
        ads_pub.add(AdsModel.fromJson(ads));
      }
    }
    if (json["number_prefixes"].isNotEmpty) {
      for (var prefix in json['number_prefixes']) {
        
        phone_num_prefix.add(prefix);
      }
    }

    id = json['id'];
    image = json['image'];
    countryCode = json['countryCode'];
    countryName = json['countryName'];
    currency = Currency.fromJson(json['currency'] ?? Currency());
    operators = opr;
    exchangeRate = json['exchangeRate']?.toDouble();
    vatRate = json['vatRate']?.toDouble();
    kycRequirements = json['kycRequirements'];
    fee = json["fee"];
    reportingRequirement = json['reportingRequirement'];
    paymentMethods = json['paymentMethods'];
    enablePaypal = json["enable_paypal"];
    enableStripe = json["enable_stripe"];
    bankCodes = json['bankCodes'];
    language = json['language'];
    countryType = json['country_type'];
    supportContact = json['supportContact'];
    supportDetail = json['supportDetail'];
    phoneNumberLimit = json['phone_number_limit'] ?? 10;
    serviceCharge = json['serviceCharge']?.toDouble();
    settlementPeriod = json['settlementPeriod'];
    status = json['status'];
    totalReq = json['totalReq'];
    failedReq = json['failedReq'];
    dailyTransactionLimit = json['dailyTransactionLimit']?.toDouble();
    monthlyTransactionLimit = json['monthlyTransactionLimit']?.toDouble();
    minTransactionAmount = double.parse(json['min_transaction_amount']??"0");
    maxTransactionAmount = double.parse(json['max_transaction_amount']??"0");
    ads = ads_pub;
    numberPrefixes = phone_num_prefix;
  }
}

class OperatorModel {
  int? id;
  String? name;
  String? slug;
  String? icon;
  String? fee;
  String? paymentInfo;
  int? totalReq;
  int? failedReq;
  num? dailyTransactionLimit;
  num? monthlyTransactionLimit;
  num? minTransactionAmount;
  num? maxTransactionAmount;
  String? status;
  String? thirdParty;
  String? type;

  OperatorModel({
    this.name,
    this.id,
    this.slug,
    this.icon,
    this.fee,
    this.paymentInfo,
    this.totalReq,
    this.failedReq,
    this.dailyTransactionLimit,
    this.monthlyTransactionLimit,
    this.minTransactionAmount,
    this.maxTransactionAmount,
    this.status,
    this.thirdParty,
    this.type,
  });
  OperatorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    icon = json['icon'];
    fee = (json['fee'] != null) ? json['fee'] : null;
    paymentInfo = json['paymentInfo'];
    totalReq = json['totalReq'];
    failedReq = json['failedReq'];
    dailyTransactionLimit = (json['dailyTransactionLimit'] != null)
        ? json['dailyTransactionLimit'].toDouble()
        : null;
    monthlyTransactionLimit = (json['monthlyTransactionLimit'] != null)
        ? json['monthlyTransactionLimit'].toDouble()
        : null;
    minTransactionAmount = (json['minTransactionAmount'] != null)
        ? json['minTransactionAmount'].toDouble()
        : null;
    maxTransactionAmount = (json['maxTransactionAmount'] != null)
        ? json['maxTransactionAmount'].toDouble()
        : null;
    status = json['status'];
    thirdParty = json['thirdParty'];
    type = json['type'];
  }
}

class AdsModel {
  String? title;
  String? details;
  String? image;
  String? link;
  DateTime? startDate;
  DateTime? endDate;
  String? status;

  AdsModel({
    this.title,
    this.details,
    this.image,
    this.link,
    this.startDate,
    this.endDate,
    this.status,
  });
  AdsModel.fromJson(Map<String, dynamic> json) {
    print("this are from ads");
    print(json["image"]);
    String hllo = "";

    title = json['title'];
    details = json['details'];
    if (json["image"].contains("http")) {
      image = json['image'];
    } else {
      image = serverAddress1 + json['image'];
    }

    link = json['link'];
    startDate =
        json['startDate'] != null ? DateTime.parse(json['startDate']) : null;
    endDate = json['endDate'] != null ? DateTime.parse(json['endDate']) : null;
    status = json['status'];
  }
}
