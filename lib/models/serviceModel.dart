class ServiceModel {
  String? logo;
  int? withdrawalFee;
  int? paymentFee;
  int? focusWithdrawalFee;
  int? focusPaymentFee;
  int? withdrawalLimit;
  int? minWithdrawal;
  int? maxWithdrawal;
  int? minPayment;
  int? maxPayment;
  String? countryCode;
  bool? status;
  
 

  ServiceModel(
      {this.logo,
      this.withdrawalFee,
      this.paymentFee,
      this.focusWithdrawalFee,
      this.focusPaymentFee,
      this.withdrawalLimit,
      this.minWithdrawal,
      this.maxWithdrawal,
      this.minPayment,
      this.maxPayment,
      this.countryCode,
      this.status,
    });

  ServiceModel.fromJson(Map<String, dynamic> json) {
    logo = json['logo'];
    withdrawalFee = json['withdrawal_fee'];
    paymentFee = json['payment_fee'];
    focusWithdrawalFee = json['focus_withdrawal_fee'];
    focusPaymentFee = json['focus_payment_fee'];
    withdrawalLimit = json['withdrawal_limit'];
    minWithdrawal = json['min_withdrawal'];
    maxWithdrawal = json['max_withdrawal'];
    minPayment = json['min_payment'];
    maxPayment = json['max_payment'];
    countryCode = json['country_code'];
    status = json['status'];
   
  }

 
}
