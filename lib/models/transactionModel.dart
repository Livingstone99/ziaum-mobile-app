import 'package:switch_app/models/countryModel.dart';

class TransactionModel {
  final int? id;
  final String? transactionId;
  final String? transactionType;
  final String? bankId;
  final String? amount;
  final int? receivedAmount;
  final String? baseRateSnapshot;
  final String? cardStatus;
  final String? mobileMoneyStatus;
  final String? reason;

  final String? referenceId;
  final String? operatorFee;
  final String? switchFee;
  final String? cardFee;
  final String? totalFee;
  final CountryModel? receiverCountry;
  final String? beneficiaryName;
  final String? countryName;
  final String? countryImage;
  final String? beneficiaryNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? paymentIntent;
  final String? disburseId;
  final String? thirdPartyTransactionId;
  final String? disburseTxId;
  final Map<String, dynamic>? responseData;
  final String? userId;
  final OperatorModel? mobileMoneyOperator;
  final String? depositOperator;

  TransactionModel({
    this.id,
    this.transactionId,
    this.transactionType,
    this.countryName,
    this.mobileMoneyStatus,
    this.receiverCountry,
    this.countryImage,
    this.bankId,
    this.amount,
    this.cardStatus,
    this.reason,
    this.referenceId,
    this.operatorFee,
    this.switchFee,
    this.cardFee,
    this.receivedAmount,
    this.totalFee,
    this.beneficiaryName,
    this.beneficiaryNumber,
    this.createdAt,
    this.updatedAt,
    this.paymentIntent,
    this.disburseId,
    this.thirdPartyTransactionId,
    this.disburseTxId,
    this.baseRateSnapshot,
    this.responseData,
    this.userId,
    this.mobileMoneyOperator,
    this.depositOperator,
  });

  static TransactionModel fromJson(Map<String, dynamic> json) {
    return TransactionModel(
        id: json['id'],
        transactionId: json['transaction_id'],
        transactionType: json['transaction_type'],
        bankId: json['bankId'] ?? "",
        amount: json['amount'] ?? "0",
        cardStatus: json['card_status'],
        mobileMoneyStatus: json['mobile_money_status'],
        reason: json['reason'] ?? "",
        referenceId: json['reference_id'],
        receiverCountry: (json["receiver_country"] == null)
            ? CountryModel()
            : CountryModel.fromJson(json["receiver_country"]),
        operatorFee: json['operator_fee'] ?? "",
        switchFee: json['switch_fee'] ?? "",
        cardFee: json['card_fee'] ?? "",
        totalFee: json['total_fee'],
        beneficiaryName: json['beneficiary_name'] ?? "Beneficiary",
        beneficiaryNumber: json['beneficiary_number'] ?? "0704090795",
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : DateTime.parse(json['createdAt']),
        paymentIntent: json['payment_intent'],
        disburseId: json['disburse_id'],
        thirdPartyTransactionId: json['third_party_transaction_id'],
        disburseTxId: json['disburse_tx_id'] ?? "",
        responseData: json['response_data'] ?? {},
        userId: json['userId'],
        mobileMoneyOperator: json['mobile_money_operator'] == null
            ? OperatorModel()
            : OperatorModel.fromJson(json["mobile_money_operator"]),
        depositOperator: json['deposit_operator'] ?? "",
        receivedAmount: json['received_amount'] ?? "",
        baseRateSnapshot: json["base_rate_snapshot"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'transaction_type': transactionType,
      'bankId': bankId,
      'amount': amount,
      'status': cardStatus,
      'reason': reason,
      'reference_id': referenceId,
      'operator_fee': operatorFee,
      'switch_fee': switchFee,
      'card_fee': cardFee,
      'total_fee': totalFee,
      'beneficiary_name': beneficiaryName,
      'beneficiary_number': beneficiaryNumber,
      'createdAt': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'payment_intent': paymentIntent,
      'disburse_id': disburseId,
      'third_party_transaction_id': thirdPartyTransactionId,
      'disburse_tx_id': disburseTxId,
      'response_data': responseData,
      'userId': userId,
      'mobile_money_operator': mobileMoneyOperator,
      'deposit_operator': depositOperator,
    };
  }
}
