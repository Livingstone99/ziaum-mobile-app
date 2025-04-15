
class TransactionResponse {
  late bool loading;
  late bool transactionSuccessful;
  late String paymentLink;

  TransactionResponse({
    this.loading = false,
    this.transactionSuccessful = false,
    this.paymentLink = "",
  });
  TransactionResponse.fromJson(Map<String, dynamic> json) {
    loading = json['loading'];
    paymentLink = json["paymentLink"];
    transactionSuccessful = json["transactionSuccessful"];
  }
  TransactionResponse copyWith({
    bool? loading,
    bool? transactionSuccessful,
    String? paymentLink,
  }) {
    return TransactionResponse(
      loading: loading ?? this.loading,
      transactionSuccessful:
          transactionSuccessful ?? this.transactionSuccessful,
      paymentLink: paymentLink ?? this.paymentLink,
    );
  }
}
