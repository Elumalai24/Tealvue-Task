import 'package:flutter/foundation.dart';
import '../model/portfolio_model.dart';
import '../services/stock_service.dart';
import '../services/esg_service.dart';
import '../services/storage_service.dart';

enum PortfolioStatus { idle, loading, loaded, error }

class PortfolioProvider extends ChangeNotifier {
  final StockService _stockService = StockService();
  final EsgService _esgService = EsgService();
  final StorageService _storageService = StorageService();

  List<PortfolioItem> _items = [];
  PortfolioStatus _status = PortfolioStatus.idle;
  String _errorMessage = '';

  List<PortfolioItem> get items => List.unmodifiable(_items);
  PortfolioStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get isLoading => _status == PortfolioStatus.loading;

  double get totalPortfolioValue =>
      _items.fold(0.0, (sum, item) => sum + item.currentValue);

  double get totalCO2Emissions =>
      _items.fold(0.0, (sum, item) => sum + item.co2Emissions);

  double get greenScore {
    if (totalPortfolioValue == 0) return 0;
    final weighted = _items.fold(
      0.0,
      (sum, item) => sum + (item.currentValue * item.esgScore),
    );
    return weighted / totalPortfolioValue;
  }

  Future<void> loadPortfolio() async {
    _status = PortfolioStatus.loading;
    notifyListeners();
    try {
      _items = await _storageService.loadPortfolio();
      if (_items.isNotEmpty) {
        await _refreshAllData();
      }
      _status = PortfolioStatus.loaded;
    } catch (e) {
      _errorMessage = 'Failed to load portfolio: $e';
      _status = PortfolioStatus.error;
    }
    notifyListeners();
  }

  Future<void> addStock(String symbol, double shares) async {
    if (_items.any((i) => i.symbol.toUpperCase() == symbol.toUpperCase())) {
      return;
    }

    _status = PortfolioStatus.loading;
    notifyListeners();

    try {
      final id =
          '${symbol.toUpperCase()}_${DateTime.now().millisecondsSinceEpoch}';
      final item = PortfolioItem(
        id: id,
        symbol: symbol.toUpperCase(),
        shares: shares,
      );

      final stockData = await _stockService.fetchStockPrice(symbol);
      final esgData = await _esgService.fetchEsgData(symbol);

      _items.add(item.copyWith(stockData: stockData, esgData: esgData));
      await _storageService.savePortfolio(_items);
      _status = PortfolioStatus.loaded;
    } catch (e) {
      _errorMessage = 'Failed to add stock: $e';
      _status = PortfolioStatus.error;
    }
    notifyListeners();
  }

  Future<void> removeStock(String id) async {
    _items.removeWhere((i) => i.id == id);
    await _storageService.savePortfolio(_items);
    notifyListeners();
  }

  Future<void> updateShares(String id, double shares) async {
    final index = _items.indexWhere((i) => i.id == id);
    if (index < 0) return;
    _items[index] = _items[index].copyWith(shares: shares);
    await _storageService.savePortfolio(_items);
    notifyListeners();
  }

  Future<void> refreshPortfolio() async {
    if (_items.isEmpty) return;
    _status = PortfolioStatus.loading;
    notifyListeners();
    await _refreshAllData();
    _status = PortfolioStatus.loaded;
    notifyListeners();
  }

  Future<void> _refreshAllData() async {
    for (int i = 0; i < _items.length; i++) {
      final stockData = await _stockService.fetchStockPrice(_items[i].symbol);
      final esgData = await _esgService.fetchEsgData(_items[i].symbol);
      _items[i] = _items[i].copyWith(stockData: stockData, esgData: esgData);
    }
    await _storageService.savePortfolio(_items);
  }
}
