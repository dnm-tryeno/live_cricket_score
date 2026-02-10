import 'package:flutter/material.dart';
import '../data/models/match_model.dart';
import '../constants/cricket_colors.dart';

/// Widget to display a live cricket match card
class LiveMatchCard extends StatelessWidget {
  final MatchModel match;
  final VoidCallback? onTap;
  /// When true, shows "Completed" badge instead of "Live" badge
  final bool isCompleted;

  const LiveMatchCard({
    super.key,
    required this.match,
    this.onTap,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: CricketColors.primaryBlue.withOpacity(0.1),
          highlightColor: CricketColors.primaryBlue.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Live indicator + Match type + More icon
                _buildHeader(),

                const SizedBox(height: 12),

                // Match name
                _buildMatchName(),

                const SizedBox(height: 12),

                // Teams and scores
                _buildTeamsAndScores(),

                const SizedBox(height: 12),

                // Venue and status
                _buildVenueAndStatus(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Status badge: Completed or Live
        if (isCompleted) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: CricketColors.accentGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Completed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ] else if (match.matchStarted && !match.matchEnded) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: CricketColors.primaryOrange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Live',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],

        // Match type badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: CricketColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            match.matchType.toUpperCase(),
            style: TextStyle(
              color: CricketColors.primaryBlue,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const Spacer(),

        // More icon
        Icon(
          Icons.more_vert,
          color: CricketColors.textGrey.withOpacity(0.6),
          size: 20,
        ),
      ],
    );
  }

  Widget _buildMatchName() {
    return Text(
      match.name,
      style: const TextStyle(
        color: CricketColors.textBlack,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTeamsAndScores() {
    // Get latest 2 innings for display
    final displayScores = match.score.length > 2
        ? match.score.sublist(match.score.length - 2)
        : match.score;

    return Column(
      children: [
        // Team 1
        if (match.teamInfo.isNotEmpty)
          _buildTeamScore(
            teamInfo: match.teamInfo[0],
            score: displayScores.isNotEmpty ? displayScores[0] : null,
          ),

        const SizedBox(height: 8),

        // Team 2
        if (match.teamInfo.length > 1)
          _buildTeamScore(
            teamInfo: match.teamInfo[1],
            score: displayScores.length > 1 ? displayScores[1] : null,
          ),
      ],
    );
  }

  Widget _buildTeamScore({required dynamic teamInfo, required dynamic score}) {
    return Row(
      children: [
        // Team logo
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            teamInfo.img,
            width: 32,
            height: 32,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback if image fails to load
              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: CricketColors.backgroundLight,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    teamInfo.shortname?.substring(0, 1) ?? 'T',
                    style: const TextStyle(
                      color: CricketColors.textBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(width: 12),

        // Team name/shortname
        Expanded(
          child: Text(
            teamInfo.shortname ?? teamInfo.name,
            style: const TextStyle(
              color: CricketColors.textBlack,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Score or status for upcoming matches
        if (score != null)
          Text(
            '${score.r}/${score.w} (${score.o.toStringAsFixed(1)} ov)',
            style: const TextStyle(
              color: CricketColors.primaryBlue,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          )
        else if (!match.matchStarted)
          Text(
            'Yet to start',
            style: TextStyle(
              color: CricketColors.textGrey.withOpacity(0.7),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }

  Widget _buildVenueAndStatus() {
    final isUpcoming = !match.matchStarted && !match.matchEnded;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Venue
        if (match.venue.isNotEmpty)
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 14,
                color: CricketColors.textGrey.withOpacity(0.7),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  match.venue,
                  style: TextStyle(color: CricketColors.textGrey, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

        if (match.venue.isNotEmpty && (isUpcoming || match.date.isNotEmpty))
          const SizedBox(height: 4),

        // Date for upcoming matches
        if (isUpcoming && match.date.isNotEmpty)
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 13,
                color: CricketColors.textGrey.withOpacity(0.7),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  match.date,
                  style: TextStyle(
                    color: CricketColors.textGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

        if ((isUpcoming && match.date.isNotEmpty) || (!isUpcoming && match.venue.isNotEmpty))
          const SizedBox(height: 4),

        // Match status
        if (match.status.isNotEmpty)
          Text(
            match.status,
            style: TextStyle(
              color: (isCompleted || match.matchEnded)
                  ? CricketColors.textGrey
                  : (match.matchStarted && !match.matchEnded)
                      ? CricketColors.primaryOrange
                      : CricketColors.primaryBlue,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
