import 'package:flutter/material.dart';

import '../model/esg_model.dart';

class EsgScoreBadge extends StatelessWidget {
  final double esgScore;
  final String sustainabilityRating;
  final double size;

  const EsgScoreBadge({
    super.key,
    required this.esgScore,
    required this.sustainabilityRating,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final category = _getCategory(esgScore);
    final color = _getColor(category);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.85), color],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          sustainabilityRating,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: size * 0.35,
          ),
        ),
      ),
    );
  }

  EsgCategory _getCategory(double score) {
    if (score >= 70) return EsgCategory.green;
    if (score >= 45) return EsgCategory.yellow;
    return EsgCategory.red;
  }

  Color _getColor(EsgCategory category) {
    switch (category) {
      case EsgCategory.green:
        return const Color(0xFF00C853);
      case EsgCategory.yellow:
        return const Color(0xFFFFAB00);
      case EsgCategory.red:
        return const Color(0xFFFF1744);
    }
  }
}

class EsgScoreBar extends StatelessWidget {
  final double score;
  final double height;

  const EsgScoreBar({super.key, required this.score, this.height = 8});

  @override
  Widget build(BuildContext context) {
    final color = _getColor(score);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ESG Score',
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(
                  context,
                ).textTheme.bodySmall?.color?.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${score.toStringAsFixed(1)}/100',
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: Stack(
            children: [
              Container(
                height: height,
                width: double.infinity,
                color: color.withOpacity(0.15),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                height: height,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: (score / 100).clamp(0, 1),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height / 2),
                      gradient: LinearGradient(
                        colors: [color.withOpacity(0.7), color],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getColor(double score) {
    if (score >= 70) return const Color(0xFF00C853);
    if (score >= 45) return const Color(0xFFFFAB00);
    return Color(0xFFFF1744);
  }
}
