class StockModel {
  final String symbol;
  final String companyName;
  final double price;
  final double change;
  final double changePercent;
  final DateTime lastUpdated;

  StockModel({
    required this.symbol,
    required this.companyName,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'companyName': companyName,
    'price': price,
    'change': change,
    'changePercent': changePercent,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory StockModel.fromJson(Map<String, dynamic> json) => StockModel(
    symbol: json['symbol'] as String,
    companyName: json['companyName'] as String? ?? json['symbol'] as String,
    price: (json['price'] as num).toDouble(),
    change: (json['change'] as num?)?.toDouble() ?? 0.0,
    changePercent: (json['changePercent'] as num?)?.toDouble() ?? 0.0,
    lastUpdated: json['lastUpdated'] != null
        ? DateTime.parse(json['lastUpdated'] as String)
        : DateTime.now(),
  );

  factory StockModel.fromAlphaVantage(Map<String, dynamic> json) {
    final quote = json['Global Quote'] as Map<String, dynamic>? ?? {};
    return StockModel(
      symbol: quote['01. symbol'] as String? ?? '',
      companyName: quote['01. symbol'] as String? ?? '',
      price: double.tryParse(quote['05. price'] as String? ?? '0') ?? 0.0,
      change: double.tryParse(quote['09. change'] as String? ?? '0') ?? 0.0,
      changePercent:
          double.tryParse(
            (quote['10. change percent'] as String? ?? '0%').replaceAll(
              '%',
              '',
            ),
          ) ??
          0.0,
      lastUpdated: DateTime.now(),
    );
  }
}
