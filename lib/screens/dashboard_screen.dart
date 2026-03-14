import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/portfolio_provider.dart';
import '../providers/theme_providers.dart';
import '../widgets/green_score_gauge.dart';
import '../widgets/co2_chart.dart';
import '../widgets/stock_card_widget.dart';
import '../widgets/summary_card_widget.dart';
import 'add_stock_screen.dart';
import 'portfolio_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<PortfolioProvider>(context, listen: false).loadPortfolio();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final portfolio = Provider.of<PortfolioProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Green Portfolio"),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: portfolio.refreshPortfolio,
        child: portfolio.isLoading
            ? Center(child: CircularProgressIndicator())
            : portfolio.items.isEmpty
            ? _buildEmptyState(context)
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSummarySection(portfolio),
                  const SizedBox(height: 20),

                  Center(
                    child: GreenScoreGauge(
                      score: portfolio.greenScore,
                      size: 180,
                    ),
                  ),

                  SizedBox(height: 20),

                  if (_getCombinedCO2Trend(portfolio).isNotEmpty)
                    CO2Chart(
                      data: _getCombinedCO2Trend(portfolio),
                      title: "Portfolio CO2 Trend",
                    ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your Holdings",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        child: const Text("View All"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PortfolioScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  ...portfolio.items
                      .take(3)
                      .map(
                        (item) => StockCard(
                          item: item,
                          onTap: () {
                            _showStockDetail(context, item);
                          },
                          onDelete: () {
                            _confirmDelete(context, portfolio, item);
                          },
                        ),
                      )
                      .toList(),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddStock(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummarySection(PortfolioProvider portfolio) {
    final currency = NumberFormat.currency(symbol: "\$", decimalDigits: 2);

    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            title: "Portfolio Value",
            value: currency.format(portfolio.totalPortfolioValue),
            icon: Icons.account_balance_wallet,
            iconColor: Colors.blue,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SummaryCard(
            title: "Total CO2",
            value: "${portfolio.totalCO2Emissions.toStringAsFixed(1)} t",
            icon: Icons.cloud,
            iconColor: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text("Add Stock"),
        onPressed: () {
          _navigateToAddStock(context);
        },
      ),
    );
  }

  List<double> _getCombinedCO2Trend(PortfolioProvider portfolio) {
    List<double> result = [];

    for (var item in portfolio.items) {
      if (item.esgData != null && item.esgData!.historicalCO2.isNotEmpty) {
        result = item.esgData!.historicalCO2;
        break;
      }
    }

    return result;
  }

  void _navigateToAddStock(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddStockScreen()),
    );
  }

  void _showStockDetail(BuildContext context, dynamic item) {
    if (item.esgData == null) return;

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Text("${item.symbol} ESG Score: ${item.esgData!.esgScore}"),
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    PortfolioProvider portfolio,
    dynamic item,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Remove Stock"),
          content: Text("Remove ${item.symbol}?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("Remove"),
              onPressed: () {
                portfolio.removeStock(item.id);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
