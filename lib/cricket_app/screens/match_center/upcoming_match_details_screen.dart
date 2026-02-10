import 'package:flutter/material.dart';
import '../../constants/cricket_ad_constants.dart';
import '../../constants/cricket_colors.dart';
import '../../constants/cricket_text_styles.dart';
import '../../data/models/match_model.dart';
import '../../shared/services/cricket_ad_service.dart';

/// Upcoming Match Details Screen
/// Shows details for upcoming/scheduled matches
class UpcomingMatchDetailsScreen extends StatefulWidget {
  final MatchModel match;

  const UpcomingMatchDetailsScreen({super.key, required this.match});

  @override
  State<UpcomingMatchDetailsScreen> createState() =>
      _UpcomingMatchDetailsScreenState();
}

class _UpcomingMatchDetailsScreenState
    extends State<UpcomingMatchDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  static const _lightText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: CricketColors.textBlack,
    letterSpacing: 0.1,
  );
  static const _lightBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: CricketColors.textBlack,
    letterSpacing: 0.1,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CricketColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: CricketColors.backgroundWhite,
        elevation: 0,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CricketColors.backgroundLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back,
              color: CricketColors.textBlack,
              size: 20,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'Match Details',
          style: CricketTextStyles.bodyMedium.copyWith(
            color: CricketColors.textBlack,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildMatchInfoCard(),
            const SizedBox(height: 20),
            _buildAdCard(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchInfoCard() {
    final match = widget.match;
    final team1 = match.teamInfo.isNotEmpty ? match.teamInfo[0] : null;
    final team2 = match.teamInfo.length > 1 ? match.teamInfo[1] : null;

    // Get team names from teamInfo first, fallback to teams array
    String team1Name =
        team1?.name ?? (match.teams.isNotEmpty ? match.teams[0] : 'TBA');
    String team2Name =
        team2?.name ?? (match.teams.length > 1 ? match.teams[1] : 'TBA');

    // Format date/time
    String dateTimeStr = match.date;
    if (match.dateTimeGMT.isNotEmpty) {
      try {
        final dt = DateTime.parse(match.dateTimeGMT);
        final months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        final month = months[dt.month - 1];
        final day = dt.day;
        final year = dt.year;
        final hour = dt.hour > 12
            ? dt.hour - 12
            : (dt.hour == 0 ? 12 : dt.hour);
        final minute = dt.minute.toString().padLeft(2, '0');
        final amPm = dt.hour >= 12 ? 'PM' : 'AM';
        dateTimeStr = '$month $day $year $hour:$minute $amPm';
      } catch (e) {
        dateTimeStr = match.date;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Match title - centered
          Center(
            child: Text(
              match.name,
              style: _lightBold.copyWith(
                color: CricketColors.textBlack,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 20),
          // Match Info Card
          Container(
            decoration: BoxDecoration(
              color: CricketColors.backgroundWhite,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Match Info :',
                    style: _lightBold.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: CricketColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Team 1', team1Name),
                  const SizedBox(height: 12),
                  _buildInfoRow('Team 2', team2Name),
                  if (dateTimeStr.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildInfoRow('Date/Time', dateTimeStr),
                  ],
                  if (match.venue.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildInfoRow('Venue', match.venue),
                  ],
                  if (match.matchType.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildInfoRow('Category', match.matchType.toUpperCase()),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdCard() {
    const double placeholderHeight = CricketAdConstants.adHeight;

    // Show native ad for both Android and iOS
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: placeholderHeight,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: CricketColors.backgroundWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                top: 8,
                bottom: 16,
              ),
              child: CricketAdService.getNativeAdWidget(
                height: placeholderHeight,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: _lightText.copyWith(
              fontSize: 14,
              color: CricketColors.textGrey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: _lightText.copyWith(
              fontSize: 14,
              color: CricketColors.textBlack,
            ),
          ),
        ),
      ],
    );
  }
}
