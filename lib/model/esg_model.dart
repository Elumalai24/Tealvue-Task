class EsgData {
  final String symbol;
  final double esgScore;
  final double co2Emissions;
  final String sustainabilityRating;
  final String sector;
  final List<EcoAlternative> ecoAlternatives;
  final List<double> historicalCO2;

  EsgData({
    required this.symbol,
    required this.esgScore,
    required this.co2Emissions,
    required this.sustainabilityRating,
    required this.sector,
    this.ecoAlternatives = const [],
    this.historicalCO2 = const [],
  });

  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'esgScore': esgScore,
    'co2Emissions': co2Emissions,
    'sustainabilityRating': sustainabilityRating,
    'sector': sector,
    'ecoAlternatives': ecoAlternatives.map((e) => e.toJson()).toList(),
    'historicalCO2': historicalCO2,
  };

  factory EsgData.fromJson(Map<String, dynamic> json) => EsgData(
    symbol: json['symbol'] as String,
    esgScore: (json['esgScore'] as num).toDouble(),
    co2Emissions: (json['co2Emissions'] as num).toDouble(),
    sustainabilityRating: json['sustainabilityRating'] as String,
    sector: json['sector'] as String,
    ecoAlternatives:
        (json['ecoAlternatives'] as List<dynamic>?)
            ?.map((e) => EcoAlternative.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    historicalCO2:
        (json['historicalCO2'] as List<dynamic>?)
            ?.map((e) => (e as num).toDouble())
            .toList() ??
        [],
  );

  EsgCategory get category {
    if (esgScore >= 70) return EsgCategory.green;
    if (esgScore >= 45) return EsgCategory.yellow;
    return EsgCategory.red;
  }
}

enum EsgCategory { green, yellow, red }

class EcoAlternative {
  final String symbol;
  final String companyName;
  final double esgScore;

  EcoAlternative({
    required this.symbol,
    required this.companyName,
    required this.esgScore,
  });

  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'companyName': companyName,
    'esgScore': esgScore,
  };

  factory EcoAlternative.fromJson(Map<String, dynamic> json) => EcoAlternative(
    symbol: json['symbol'] as String,
    companyName: json['companyName'] as String,
    esgScore: (json['esgScore'] as num).toDouble(),
  );
}
