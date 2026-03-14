import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';

class AddStockScreen extends StatefulWidget {
  const AddStockScreen({super.key});

  @override
  State<AddStockScreen> createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final _symbolController = TextEditingController();
  final _sharesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isAdding = false;

  static const _popularStocks = [
    {'symbol': 'AAPL', 'name': 'Apple Inc.', 'esg': 72.5},
    {'symbol': 'MSFT', 'name': 'Microsoft Corp.', 'esg': 83.2},
    {'symbol': 'TSLA', 'name': 'Tesla Inc.', 'esg': 65.0},
    {'symbol': 'GOOGL', 'name': 'Alphabet Inc.', 'esg': 76.8},
    {'symbol': 'AMZN', 'name': 'Amazon.com Inc.', 'esg': 48.5},
    {'symbol': 'NVDA', 'name': 'NVIDIA Corp.', 'esg': 58.3},
    {'symbol': 'META', 'name': 'Meta Platforms', 'esg': 44.7},
    {'symbol': 'NFLX', 'name': 'Netflix Inc.', 'esg': 52.1},
    {'symbol': 'NEE', 'name': 'NextEra Energy', 'esg': 88.5},
    {'symbol': 'ENPH', 'name': 'Enphase Energy', 'esg': 91.2},
  ];

  @override
  void dispose() {
    _symbolController.dispose();
    _sharesController.dispose();
    super.dispose();
  }

  Future<void> _addStock() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isAdding = true);

    final provider = context.read<PortfolioProvider>();
    await provider.addStock(
      _symbolController.text.trim().toUpperCase(),
      double.parse(_sharesController.text.trim()),
    );

    if (mounted) {
      setState(() => _isAdding = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_symbolController.text.trim().toUpperCase()} added to portfolio',
          ),
          backgroundColor: const Color(0xFF00C853),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _selectPopularStock(Map<String, dynamic> stock) {
    _symbolController.text = stock['symbol'] as String;
    _sharesController.text = '10';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Stock',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C853).withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_chart_rounded,
                    size: 48,
                    color: Color(0xFF00C853),
                  ),
                ),
              ),
              SizedBox(height: 28),

              const Text(
                'Stock Symbol',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _symbolController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  hintText: 'e.g. AAPL, TSLA, MSFT',
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Color(0xFF00C853),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a stock symbol';
                  }
                  if (value.trim().length > 6) {
                    return 'Symbol should be 1-6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              const Text(
                'Number of Shares',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _sharesController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  hintText: 'e.g. 10',
                  prefixIcon: Icon(
                    Icons.inventory_2_outlined,
                    color: Color(0xFF00C853),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter number of shares';
                  }
                  final shares = double.tryParse(value.trim());
                  if (shares == null || shares <= 0) {
                    return 'Enter a valid number greater than 0';
                  }
                  return null;
                },
              ),
              SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isAdding ? null : _addStock,
                  child: _isAdding
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_rounded, size: 20),
                            SizedBox(width: 8),
                            Text('Add to Portfolio'),
                          ],
                        ),
                ),
              ),

              SizedBox(height: 36),

              const Text(
                'Popular Stocks',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 4),
              Text(
                'Tap to quick-fill stock symbol',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
              SizedBox(height: 14),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _popularStocks.map((stock) {
                  final esg = stock['esg'] as double;
                  final color = esg >= 70
                      ? const Color(0xFF00C853)
                      : esg >= 45
                      ? const Color(0xFFFFAB00)
                      : const Color(0xFFFF1744);

                  return GestureDetector(
                    onTap: () => _selectPopularStock(stock),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: theme.cardTheme.color,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.dividerColor.withOpacity(0.1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stock['symbol'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                stock['name'] as String,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
