import '../model/esg_model.dart';

class EsgService {
  static final Map<String, EsgData> _mockDatabase = {
    'AAPL': EsgData(
      symbol: 'AAPL',
      esgScore: 72.5,
      co2Emissions: 22.6,
      sustainabilityRating: 'A',
      sector: 'Technology',
      historicalCO2: [28.1, 26.4, 24.8, 23.5, 22.9, 22.6],
      ecoAlternatives: [],
    ),
    'TSLA': EsgData(
      symbol: 'TSLA',
      esgScore: 65.0,
      co2Emissions: 18.3,
      sustainabilityRating: 'A',
      sector: 'Automotive',
      historicalCO2: [24.5, 22.8, 21.0, 19.6, 18.9, 18.3],
      ecoAlternatives: [],
    ),
    'MSFT': EsgData(
      symbol: 'MSFT',
      esgScore: 83.2,
      co2Emissions: 14.1,
      sustainabilityRating: 'A+',
      sector: 'Technology',
      historicalCO2: [18.3, 17.0, 15.8, 15.2, 14.6, 14.1],
      ecoAlternatives: [],
    ),
    'GOOGL': EsgData(
      symbol: 'GOOGL',
      esgScore: 76.8,
      co2Emissions: 16.2,
      sustainabilityRating: 'A',
      sector: 'Technology',
      historicalCO2: [21.0, 19.5, 18.1, 17.4, 16.8, 16.2],
      ecoAlternatives: [],
    ),
    'AMZN': EsgData(
      symbol: 'AMZN',
      esgScore: 48.5,
      co2Emissions: 71.5,
      sustainabilityRating: 'B',
      sector: 'E-Commerce',
      historicalCO2: [85.2, 82.1, 79.0, 76.3, 73.8, 71.5],
      ecoAlternatives: [
        EcoAlternative(
          symbol: 'MSFT',
          companyName: 'Microsoft Corp.',
          esgScore: 83.2,
        ),
        EcoAlternative(
          symbol: 'GOOGL',
          companyName: 'Alphabet Inc.',
          esgScore: 76.8,
        ),
      ],
    ),
    'NVDA': EsgData(
      symbol: 'NVDA',
      esgScore: 58.3,
      co2Emissions: 32.4,
      sustainabilityRating: 'B',
      sector: 'Semiconductors',
      historicalCO2: [40.1, 37.8, 35.2, 34.0, 33.1, 32.4],
      ecoAlternatives: [
        EcoAlternative(
          symbol: 'MSFT',
          companyName: 'Microsoft Corp.',
          esgScore: 83.2,
        ),
      ],
    ),
    'META': EsgData(
      symbol: 'META',
      esgScore: 44.7,
      co2Emissions: 45.2,
      sustainabilityRating: 'C',
      sector: 'Social Media',
      historicalCO2: [58.4, 55.1, 51.8, 49.2, 47.0, 45.2],
      ecoAlternatives: [
        EcoAlternative(
          symbol: 'MSFT',
          companyName: 'Microsoft Corp.',
          esgScore: 83.2,
        ),
        EcoAlternative(
          symbol: 'AAPL',
          companyName: 'Apple Inc.',
          esgScore: 72.5,
        ),
      ],
    ),
    'NFLX': EsgData(
      symbol: 'NFLX',
      esgScore: 52.1,
      co2Emissions: 38.7,
      sustainabilityRating: 'B',
      sector: 'Entertainment',
      historicalCO2: [48.2, 46.5, 44.1, 42.0, 40.3, 38.7],
      ecoAlternatives: [
        EcoAlternative(
          symbol: 'AAPL',
          companyName: 'Apple Inc.',
          esgScore: 72.5,
        ),
      ],
    ),
    'JPM': EsgData(
      symbol: 'JPM',
      esgScore: 38.4,
      co2Emissions: 128.6,
      sustainabilityRating: 'C',
      sector: 'Finance',
      historicalCO2: [145.2, 140.8, 137.1, 133.5, 131.0, 128.6],
      ecoAlternatives: [
        EcoAlternative(
          symbol: 'MSFT',
          companyName: 'Microsoft Corp.',
          esgScore: 83.2,
        ),
        EcoAlternative(
          symbol: 'GOOGL',
          companyName: 'Alphabet Inc.',
          esgScore: 76.8,
        ),
      ],
    ),
    'XOM': EsgData(
      symbol: 'XOM',
      esgScore: 18.2,
      co2Emissions: 582.4,
      sustainabilityRating: 'F',
      sector: 'Energy',
      historicalCO2: [620.1, 610.8, 602.5, 595.3, 589.0, 582.4],
      ecoAlternatives: [
        EcoAlternative(
          symbol: 'TSLA',
          companyName: 'Tesla Inc.',
          esgScore: 65.0,
        ),
        EcoAlternative(
          symbol: 'MSFT',
          companyName: 'Microsoft Corp.',
          esgScore: 83.2,
        ),
        EcoAlternative(
          symbol: 'AAPL',
          companyName: 'Apple Inc.',
          esgScore: 72.5,
        ),
      ],
    ),
    'NEE': EsgData(
      symbol: 'NEE',
      esgScore: 88.5,
      co2Emissions: 8.4,
      sustainabilityRating: 'A+',
      sector: 'Renewable Energy',
      historicalCO2: [12.1, 11.2, 10.3, 9.5, 8.9, 8.4],
      ecoAlternatives: [],
    ),
    'ENPH': EsgData(
      symbol: 'ENPH',
      esgScore: 91.2,
      co2Emissions: 4.2,
      sustainabilityRating: 'A+',
      sector: 'Clean Energy',
      historicalCO2: [7.8, 6.9, 6.1, 5.4, 4.8, 4.2],
      ecoAlternatives: [],
    ),
  };

  Future<EsgData?> fetchEsgData(String symbol) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final upperSymbol = symbol.toUpperCase();
    if (_mockDatabase.containsKey(upperSymbol)) {
      return _mockDatabase[upperSymbol];
    }

    return _generateGenericEsgData(upperSymbol);
  }

  EsgData _generateGenericEsgData(String symbol) {
    final hash = symbol.hashCode.abs();
    final esgScore = 30.0 + (hash % 60);
    final co2 = 20.0 + (hash % 200).toDouble();
    String rating;
    if (esgScore >= 75) {
      rating = 'A+';
    } else if (esgScore >= 65) {
      rating = 'A';
    } else if (esgScore >= 50) {
      rating = 'B';
    } else if (esgScore >= 35) {
      rating = 'C';
    } else {
      rating = 'D';
    }

    return EsgData(
      symbol: symbol,
      esgScore: esgScore.toDouble(),
      co2Emissions: co2,
      sustainabilityRating: rating,
      sector: 'Unknown',
      historicalCO2: [
        co2 * 1.3,
        co2 * 1.25,
        co2 * 1.18,
        co2 * 1.1,
        co2 * 1.05,
        co2,
      ],
      ecoAlternatives: esgScore < 50
          ? [
              EcoAlternative(
                symbol: 'NEE',
                companyName: 'NextEra Energy',
                esgScore: 88.5,
              ),
              EcoAlternative(
                symbol: 'MSFT',
                companyName: 'Microsoft Corp.',
                esgScore: 83.2,
              ),
            ]
          : [],
    );
  }

  List<EsgData> getGreenAlternatives() {
    return _mockDatabase.values.where((e) => e.esgScore >= 70).toList()
      ..sort((a, b) => b.esgScore.compareTo(a.esgScore));
  }
}
