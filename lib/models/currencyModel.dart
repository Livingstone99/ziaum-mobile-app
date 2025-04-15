class Currency {
  final int? id;
  final String? currencyName;
  final String? abbreviation;
  final String? conversionRateToBaseCurrency;
  final DateTime? timestamp;

  Currency({
    this.id,
    this.currencyName,
    this.abbreviation,
    this.conversionRateToBaseCurrency,
    this.timestamp,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      id: json['id'] as int?,
      currencyName: json['currency_name'] as String?,
      abbreviation: json['abbreviation'] as String?,
      conversionRateToBaseCurrency:
          json['conversion_rate_to_base_currency'] as String?,
      timestamp:
          json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'currency_name': currencyName,
      'abbreviation': abbreviation,
      'conversion_rate_to_base_currency': conversionRateToBaseCurrency,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}
