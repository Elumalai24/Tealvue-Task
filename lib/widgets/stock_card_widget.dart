import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/portfolio_model.dart';
import 'esg_score_badge.dart';

class StockCard extends StatelessWidget {
  final PortfolioItem item;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const StockCard({super.key, required this.item, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    final price = item.stockData?.price ?? 0;
    final change = item.stockData?.change ?? 0;
    final changePercent = item.stockData?.changePercent ?? 0;
    final isPositive = change >= 0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.cardTheme.color,
        border: Border.all(color: theme.dividerColor.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.symbol,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            item.stockData?.companyName ?? item.symbol,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textTheme.bodySmall?.color
                                  ?.withOpacity(0.55),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            currencyFormat.format(price),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                isPositive
                                    ? Icons.arrow_upward_rounded
                                    : Icons.arrow_downward_rounded,
                                size: 14,
                                color: isPositive
                                    ? const Color(0xFF00C853)
                                    : const Color(0xFFFF1744),
                              ),
                              SizedBox(width: 2),
                              Text(
                                '${isPositive ? '+' : ''}${change.toStringAsFixed(2)} (${changePercent.toStringAsFixed(2)}%)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isPositive
                                      ? const Color(0xFF00C853)
                                      : const Color(0xFFFF1744),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Column(
                      children: [
                        if (item.esgData != null)
                          EsgScoreBadge(
                            esgScore: item.esgData!.esgScore,
                            sustainabilityRating:
                                item.esgData!.sustainabilityRating,
                            size: 50,
                          ),
                        if (onDelete != null) ...[
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: onDelete,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF1744).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                size: 18,
                                color: Color(0xFFFF1744),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _InfoChip(
                            icon: Icons.inventory_2_outlined,
                            label: '${item.shares.toStringAsFixed(1)} shares',
                          ),
                          _InfoChip(
                            icon: Icons.monetization_on_outlined,
                            label: currencyFormat.format(item.currentValue),
                          ),
                          _InfoChip(
                            icon: Icons.cloud_outlined,
                            label:
                                '${item.co2Emissions.toStringAsFixed(1)}t CO₂',
                            color: _co2Color(item.co2Emissions),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      if (item.esgData != null)
                        EsgScoreBar(score: item.esgData!.esgScore),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _co2Color(double co2) {
    if (co2 < 30) return const Color(0xFF00C853);
    if (co2 < 100) return const Color(0xFFFFAB00);
    return const Color(0xFFFF1744);
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c =
        color ??
        Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6) ??
        Colors.grey;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: c),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: c),
        ),
      ],
    );
  }
}
