import 'stock_model.dart';
import 'esg_model.dart';

class PortfolioItem {
  final String id;
  final String symbol;
  final double shares;
  StockModel? stockData;
  EsgData? esgData;

  PortfolioItem({
    required this.id,
    required this.symbol,
    required this.shares,
    this.stockData,
    this.esgData,
  });

  double get currentValue => (stockData?.price ?? 0) * shares;

  double get esgScore => esgData?.esgScore ?? 0;

  double get co2Emissions => (esgData?.co2Emissions ?? 0) * shares;

  String get sustainabilityRating => esgData?.sustainabilityRating ?? 'N/A';

  Map<String, dynamic> toJson() => {
    'id': id,
    'symbol': symbol,
    'shares': shares,
    'stockData': stockData?.toJson(),
    'esgData': esgData?.toJson(),
  };

  factory PortfolioItem.fromJson(Map<String, dynamic> json) => PortfolioItem(
    id: json['id'] as String,
    symbol: json['symbol'] as String,
    shares: (json['shares'] as num).toDouble(),
    stockData: json['stockData'] != null
        ? StockModel.fromJson(json['stockData'] as Map<String, dynamic>)
        : null,
    esgData: json['esgData'] != null
        ? EsgData.fromJson(json['esgData'] as Map<String, dynamic>)
        : null,
  );

  PortfolioItem copyWith({
    String? id,
    String? symbol,
    double? shares,
    StockModel? stockData,
    EsgData? esgData,
  }) => PortfolioItem(
    id: id ?? this.id,
    symbol: symbol ?? this.symbol,
    shares: shares ?? this.shares,
    stockData: stockData ?? this.stockData,
    esgData: esgData ?? this.esgData,
  );
}
