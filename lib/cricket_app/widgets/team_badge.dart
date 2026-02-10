import 'package:flutter/material.dart';
import '../constants/cricket_text_styles.dart';

/// Team Badge Widget
/// Circular badge with team code (e.g., IND, AUS)
class TeamBadge extends StatelessWidget {
  final String teamCode;
  final Color backgroundColor;
  final double size;

  const TeamBadge({
    super.key,
    required this.teamCode,
    required this.backgroundColor,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          teamCode,
          style: CricketTextStyles.labelLarge.copyWith(
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
