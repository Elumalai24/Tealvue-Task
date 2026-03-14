import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/stock_model.dart';

class StockService {
  static const String _baseUrl = 'https://www.alphavantage.co/query';
  static const String _apiKey = 'XU5LX98J9H3ICK0C';

  Future<StockModel?> fetchStockPrice(String symbol) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl?function=GLOBAL_QUOTE&symbol=${symbol.toUpperCase()}&apikey=$_apiKey',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final quote = data['Global Quote'] as Map<String, dynamic>?;
        if (quote == null || quote.isEmpty || (quote['05. price'] == null)) {
          return _getMockStockData(symbol);
        }

        return StockModel.fromAlphaVantage(data);
      }
    } catch (e) {}
    return _getMockStockData(symbol);
  }

  Future<List<StockModel>> fetchMultipleStocks(List<String> symbols) async {
    final futures = symbols.map((s) => fetchStockPrice(s));
    final results = await Future.wait(futures);
    return results.whereType<StockModel>().toList();
  }

  StockModel? _getMockStockData(String symbol) {
    final mockData = {
      'AAPL': StockModel(
        symbol: 'AAPL',
        companyName: 'Apple Inc.',
        price: 189.30,
        change: 2.15,
        changePercent: 1.15,
        lastUpdated: DateTime.now(),
      ),
      'TSLA': StockModel(
        symbol: 'TSLA',
        companyName: 'Tesla Inc.',
        price: 245.67,
        change: -3.42,
        changePercent: -1.37,
        lastUpdated: DateTime.now(),
      ),
      'MSFT': StockModel(
        symbol: 'MSFT',
        companyName: 'Microsoft Corp.',
        price: 415.20,
        change: 5.80,
        changePercent: 1.42,
        lastUpdated: DateTime.now(),
      ),
      'GOOGL': StockModel(
        symbol: 'GOOGL',
        companyName: 'Alphabet Inc.',
        price: 175.85,
        change: 1.23,
        changePercent: 0.70,
        lastUpdated: DateTime.now(),
      ),
      'AMZN': StockModel(
        symbol: 'AMZN',
        companyName: 'Amazon.com Inc.',
        price: 198.45,
        change: -2.10,
        changePercent: -1.05,
        lastUpdated: DateTime.now(),
      ),
      'NVDA': StockModel(
        symbol: 'NVDA',
        companyName: 'NVIDIA Corp.',
        price: 875.50,
        change: 22.30,
        changePercent: 2.62,
        lastUpdated: DateTime.now(),
      ),
      'META': StockModel(
        symbol: 'META',
        companyName: 'Meta Platforms Inc.',
        price: 523.10,
        change: 8.90,
        changePercent: 1.73,
        lastUpdated: DateTime.now(),
      ),
      'NFLX': StockModel(
        symbol: 'NFLX',
        companyName: 'Netflix Inc.',
        price: 628.75,
        change: -5.25,
        changePercent: -0.83,
        lastUpdated: DateTime.now(),
      ),
      'JPM': StockModel(
        symbol: 'JPM',
        companyName: 'JPMorgan Chase & Co.',
        price: 210.40,
        change: 1.60,
        changePercent: 0.77,
        lastUpdated: DateTime.now(),
      ),
      'XOM': StockModel(
        symbol: 'XOM',
        companyName: 'Exxon Mobil Corp.',
        price: 108.35,
        change: -0.85,
        changePercent: -0.78,
        lastUpdated: DateTime.now(),
      ),
    };

    final upperSymbol = symbol.toUpperCase();
    if (mockData.containsKey(upperSymbol)) {
      return mockData[upperSymbol];
    }

    return StockModel(
      symbol: upperSymbol,
      companyName: upperSymbol,
      price: 100.00 + (upperSymbol.hashCode % 400).abs().toDouble(),
      change: (upperSymbol.hashCode % 10).toDouble() - 5,
      changePercent: ((upperSymbol.hashCode % 100).toDouble() - 50) / 50,
      lastUpdated: DateTime.now(),
    );
  }
}
