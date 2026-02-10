import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../constants/cricket_ad_constants.dart';
import '../../constants/cricket_colors.dart';
import '../../constants/cricket_text_styles.dart';
import '../../data/models/match_model.dart';
import '../../data/models/match_scorecard_response_model.dart';
import '../../data/repositories/providers/cricket_repository_provider.dart';
import '../../shared/services/cricket_ad_service.dart';

/// Live Match Details Screen
/// Shows details for live/ongoing matches with real-time updates
class LiveMatchDetailsScreen extends ConsumerStatefulWidget {
  final MatchModel match;

  const LiveMatchDetailsScreen({super.key, required this.match});

  @override
  ConsumerState<LiveMatchDetailsScreen> createState() =>
      _LiveMatchDetailsScreenState();
}

class _LiveMatchDetailsScreenState
    extends ConsumerState<LiveMatchDetailsScreen> {
  late int _selectedTab; // 0: Summary, 1: Scoreboard
  MatchScorecardData? _scorecard;
  bool _scorecardLoading = true;
  String? _scorecardError;
  bool _scorecardLoadInProgress = false;

  @override
  void initState() {
    super.initState();
    _selectedTab = 1;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadScorecard());
  }

  Future<void> _loadScorecard() async {
    if (!mounted) return;
    if (_scorecardLoadInProgress) return;
    _scorecardLoadInProgress = true;
    setState(() => _scorecardLoading = true);
    try {
      final repo = ref.read(cricketRepositoryProvider);
      final res = await repo.getMatchScorecard(widget.match.id);
      if (!mounted) return;
      setState(() {
        _scorecardLoading = false;
        if (res?.status == 'success' && res?.data != null) {
          _scorecard = res!.data;
          _scorecardError = null;
        } else {
          _scorecard = null;
          _scorecardError = 'Scorecard not available';
        }
      });
    } finally {
      if (mounted) _scorecardLoadInProgress = false;
    }
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
  static const _lightSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: CricketColors.textGrey,
    letterSpacing: 0.2,
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
          icon: Icon(
            Icons.arrow_back,
            color: CricketColors.textBlack,
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.match.teamInfo.isNotEmpty
                  ? (widget.match.teamInfo[0].shortname ??
                        widget.match.teamInfo[0].name
                            .substring(0, 3)
                            .toUpperCase())
                  : 'T1',
              style: CricketTextStyles.bodyMedium.copyWith(
                color: CricketColors.textBlack,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: CricketColors.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.sports_cricket,
                color: CricketColors.primaryBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              widget.match.teamInfo.length > 1
                  ? (widget.match.teamInfo[1].shortname ??
                        widget.match.teamInfo[1].name
                            .substring(0, 3)
                            .toUpperCase())
                  : 'T2',
              style: CricketTextStyles.bodyMedium.copyWith(
                color: CricketColors.textBlack,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: _scorecardLoadInProgress
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: CricketColors.primaryBlue,
                    ),
                  )
                : Icon(Icons.refresh, color: CricketColors.textBlack, size: 24),
            onPressed: _scorecardLoadInProgress ? null : () => _loadScorecard(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildMatchCard(),
            const SizedBox(height: 20),
            _buildAdCard(),
            const SizedBox(height: 20),
            _buildTabsAndContent(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchCard() {
    final match = widget.match;
    final team1 = match.teamInfo.isNotEmpty ? match.teamInfo[0] : null;
    final team2 = match.teamInfo.length > 1 ? match.teamInfo[1] : null;

    // Get scores
    final score1 = match.score.isNotEmpty ? match.score[0] : null;
    final score2 = match.score.length > 1 ? match.score[1] : null;

    // Calculate CRR (Current Run Rate)
    String crr = '-';
    if (score1 != null && score1.o > 0) {
      crr = (score1.r / score1.o).toStringAsFixed(2);
    }

    // Calculate RRR (Required Run Rate) - only if team2 is batting
    String rrr = '-';
    if (score2 != null && score2.o > 0 && score1 != null) {
      final remainingRuns = score1.r - score2.r;
      final remainingOvers =
          (match.matchType.contains('T20')
              ? 20.0
              : match.matchType.contains('ODI')
              ? 50.0
              : 20.0) -
          score2.o;
      if (remainingOvers > 0 && remainingRuns > 0) {
        rrr = (remainingRuns / remainingOvers).toStringAsFixed(2);
      }
    }

    // Get team codes
    final team1Code =
        team1?.shortname ??
        (team1?.name.isNotEmpty == true
            ? team1!.name.substring(0, 3).toUpperCase()
            : 'T1');
    final team2Code =
        team2?.shortname ??
        (team2?.name.isNotEmpty == true
            ? team2!.name.substring(0, 3).toUpperCase()
            : 'T2');

    // Format score strings
    String score1Str = 'Yet to bat';
    if (score1 != null) {
      score1Str = '${score1.r}/${score1.w} (${score1.o.toStringAsFixed(1)})';
    }

    String score2Str = 'Yet to bat';
    if (score2 != null) {
      score2Str = '${score2.r}/${score2.w} (${score2.o.toStringAsFixed(1)})';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
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
              // Match title and Live badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      match.name,
                      style: _lightSmall.copyWith(
                        color: CricketColors.textBlack,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Orange Live badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: CricketColors.primaryOrange,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: CricketColors.backgroundWhite,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: CricketColors.backgroundWhite,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Live',
                          style: _lightSmall.copyWith(
                            color: CricketColors.backgroundWhite,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Team 1 with flag image, code, and score
              if (team1 != null)
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: CricketColors.primaryBlue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: team1.img.isNotEmpty
                            ? Image.network(
                                team1.img,
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  if (kDebugMode) {
                                    debugPrint(
                                      '❌ Failed to load team1 flag image: ${team1.img}',
                                    );
                                  }
                                  return Container(
                                    width: 32,
                                    height: 32,
                                    color: CricketColors.primaryBlue
                                        .withOpacity(0.1),
                                    child: Icon(
                                      Icons.flag,
                                      size: 18,
                                      color: CricketColors.primaryBlue,
                                    ),
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 32,
                                        height: 32,
                                        color: CricketColors.primaryBlue
                                            .withOpacity(0.1),
                                        child: Icon(
                                          Icons.flag,
                                          size: 18,
                                          color: CricketColors.primaryBlue,
                                        ),
                                      );
                                    },
                              )
                            : Icon(
                                Icons.flag,
                                size: 18,
                                color: CricketColors.primaryBlue,
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      team1Code,
                      style: _lightBold.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      score1Str,
                      style: _lightBold.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              if (team1 != null && team2 != null) const SizedBox(height: 14),
              // Team 2 with flag image, code, and score
              if (team2 != null)
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: CricketColors.accentYellow.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: team2.img.isNotEmpty
                            ? Image.network(
                                team2.img,
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  if (kDebugMode) {
                                    debugPrint(
                                      '❌ Failed to load team2 flag image: ${team2.img}',
                                    );
                                  }
                                  return Container(
                                    width: 32,
                                    height: 32,
                                    color: CricketColors.accentYellow
                                        .withOpacity(0.1),
                                    child: Icon(
                                      Icons.flag,
                                      size: 18,
                                      color: CricketColors.accentYellow,
                                    ),
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 32,
                                        height: 32,
                                        color: CricketColors.accentYellow
                                            .withOpacity(0.1),
                                        child: Icon(
                                          Icons.flag,
                                          size: 18,
                                          color: CricketColors.accentYellow,
                                        ),
                                      );
                                    },
                              )
                            : Icon(
                                Icons.flag,
                                size: 18,
                                color: CricketColors.accentYellow,
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      team2Code,
                      style: _lightBold.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      score2Str,
                      style: _lightBold.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 18),
              // CRR and RRR in light blue rounded rectangles
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: CricketColors.liveCardBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'CRR - $crr',
                      style: _lightBold.copyWith(
                        color: CricketColors.primaryBlue,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: CricketColors.liveCardBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'RRR - $rrr',
                      style: _lightBold.copyWith(
                        color: CricketColors.primaryBlue,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
              child: CricketAdService.getNativeAdWidget(height: CricketAdConstants.adHeight),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabsAndContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs outside card
          Row(
            children: [
              _buildTab('Summary', 0),
              const SizedBox(width: 10),
              _buildTab('Scoreboard', 1),
            ],
          ),
          const SizedBox(height: 20),
          // Content in white card
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
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.05),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _selectedTab == 0
                    ? _buildSummaryContent(key: const ValueKey('summary'))
                    : _buildScoreboardContent(
                        key: const ValueKey('scoreboard'),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedTab = index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: isSelected
                ? CricketColors.primaryBlue
                : CricketColors.backgroundWhite,
            borderRadius: BorderRadius.circular(26),
            border: isSelected
                ? null
                : Border.all(color: CricketColors.primaryBlue, width: 1.5),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: CricketColors.primaryBlue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: _lightBold.copyWith(
              color: isSelected
                  ? CricketColors.backgroundWhite
                  : CricketColors.primaryBlue,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryContent({Key? key}) {
    final match = widget.match;
    final team1 = match.teamInfo.isNotEmpty ? match.teamInfo[0] : null;
    final team2 = match.teamInfo.length > 1 ? match.teamInfo[1] : null;

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

    // Build vs name
    String vsName = 'TBA';
    if (team1 != null && team2 != null) {
      vsName = '${team1.name} vs ${team2.name}';
    } else if (team1 != null) {
      vsName = '${team1.name} vs TBA';
    } else if (team2 != null) {
      vsName = 'TBA vs ${team2.name}';
    }

    return Container(
      key: key,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CricketColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
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
          _buildInfoRow('Team 1', team1?.name ?? 'TBA'),
          const SizedBox(height: 12),
          _buildInfoRow('Team 2', team2?.name ?? 'TBA'),
          const SizedBox(height: 12),
          _buildInfoRow('vs', vsName),
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
          if (match.status.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow('Status', match.status),
          ],
        ],
      ),
    );
  }

  /// Format inning title: 1st inning = batting team 1 name (e.g. Australia), 2nd inning = batting team 2 name (e.g. Pakistan).
  /// Uses score[i].inning so batting team is correct even when API returns "Pakistan,australia Inning 1".
  String _formatInningTitle(int inningIndex, MatchScorecardData scorecard) {
    String teamName;
    if (scorecard.score.length > inningIndex) {
      final inningStr = scorecard.score[inningIndex].inning;
      final match = RegExp(
        r'\s+inning\s+\d+',
        caseSensitive: false,
      ).firstMatch(inningStr);
      if (match != null) {
        final beforeInning = inningStr.substring(0, match.start).trim();
        if (beforeInning.contains(',')) {
          teamName = beforeInning.split(',').last.trim();
        } else {
          teamName = beforeInning;
        }
      } else {
        teamName = inningStr;
      }
    } else if (scorecard.teamInfo.length > inningIndex) {
      teamName = scorecard.teamInfo[inningIndex].name;
    } else if (scorecard.teams.length > inningIndex) {
      teamName = scorecard.teams[inningIndex];
    } else {
      return 'Inning ${inningIndex + 1}';
    }
    final display = teamName
        .trim()
        .split(' ')
        .map(
          (w) =>
              w.isEmpty ? w : w[0].toUpperCase() + w.substring(1).toLowerCase(),
        )
        .join(' ');
    return '$display Inning 1';
  }

  Widget _buildScoreboardContent({Key? key}) {
    if (_scorecardLoading) {
      return Container(
        key: key,
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(
          color: CricketColors.primaryBlue,
        ),
      );
    }
    if (_scorecardError != null || _scorecard == null) {
      return Container(
        key: key,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            _scorecardError ?? 'Scorecard not available',
            style: _lightText.copyWith(
              color: CricketColors.textGrey,
              fontSize: 13,
            ),
          ),
        ),
      );
    }
    return Container(
      key: key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < _scorecard!.scorecard.length; i++) ...[
            Text(
              _formatInningTitle(i, _scorecard!),
              style: _lightBold.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: CricketColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 10),
            _buildBattingTable(_scorecard!.scorecard[i].batting),
            if (_scorecard!.scorecard[i].extras != null &&
                (_scorecard!.scorecard[i].extras!.r > 0 ||
                    _scorecard!.scorecard[i].extras!.b > 0))
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Extras: ${_scorecard!.scorecard[i].extras!.r} (b ${_scorecard!.scorecard[i].extras!.b})',
                  style: _lightSmall.copyWith(color: CricketColors.textGrey),
                ),
              ),
            const SizedBox(height: 14),
            _buildBowlingTable(_scorecard!.scorecard[i].bowling),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildBattingTable(List<BattingEntryModel> batting) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: CricketColors.liveCardBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Batsman',
                  style: _lightBold.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: CricketColors.textGrey,
                  ),
                ),
              ),
              SizedBox(
                width: 36,
                child: Text(
                  'R',
                  textAlign: TextAlign.center,
                  style: _lightBold.copyWith(
                    fontSize: 12,
                    color: CricketColors.textGrey,
                  ),
                ),
              ),
              SizedBox(
                width: 36,
                child: Text(
                  'B',
                  textAlign: TextAlign.center,
                  style: _lightBold.copyWith(
                    fontSize: 12,
                    color: CricketColors.textGrey,
                  ),
                ),
              ),
              SizedBox(
                width: 32,
                child: Text(
                  '4s',
                  textAlign: TextAlign.center,
                  style: _lightBold.copyWith(
                    fontSize: 12,
                    color: CricketColors.textGrey,
                  ),
                ),
              ),
              SizedBox(
                width: 32,
                child: Text(
                  '6s',
                  textAlign: TextAlign.center,
                  style: _lightBold.copyWith(
                    fontSize: 12,
                    color: CricketColors.textGrey,
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  'SR',
                  textAlign: TextAlign.center,
                  style: _lightBold.copyWith(
                    fontSize: 12,
                    color: CricketColors.textGrey,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Out',
                  style: _lightBold.copyWith(
                    fontSize: 11,
                    color: CricketColors.textGrey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        ...batting.map((e) => _buildBattingRow(e)),
      ],
    );
  }

  Widget _buildBattingRow(BattingEntryModel e) {
    final sr = e.b > 0 ? e.sr.toStringAsFixed(1) : '0.0';
    final outText = e.dismissalText.isEmpty ? 'Not Out' : e.dismissalText;
    final name = e.dismissalText.isEmpty
        ? '${e.batsman.name} *'
        : e.batsman.name;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: _lightText.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '${e.r}',
              textAlign: TextAlign.center,
              style: _lightText.copyWith(fontSize: 13),
            ),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '${e.b}',
              textAlign: TextAlign.center,
              style: _lightText.copyWith(fontSize: 13),
            ),
          ),
          SizedBox(
            width: 32,
            child: Text(
              '${e.fours}',
              textAlign: TextAlign.center,
              style: _lightText.copyWith(fontSize: 13),
            ),
          ),
          SizedBox(
            width: 32,
            child: Text(
              '${e.sixes}',
              textAlign: TextAlign.center,
              style: _lightText.copyWith(fontSize: 13),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              sr,
              textAlign: TextAlign.center,
              style: _lightText.copyWith(fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              outText,
              style: _lightSmall.copyWith(
                fontSize: 11,
                color: CricketColors.textGrey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBowlingTable(List<BowlingEntryModel> bowling) {
    if (bowling.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bowling',
          style: _lightBold.copyWith(
            fontSize: 13,
            color: CricketColors.textGrey,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: CricketColors.liveCardBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Bowler',
                  style: _lightBold.copyWith(
                    fontSize: 12,
                    color: CricketColors.textGrey,
                  ),
                ),
              ),
              SizedBox(
                width: 32,
                child: Text(
                  'O',
                  textAlign: TextAlign.center,
                  style: _lightBold.copyWith(
                    fontSize: 12,
                    color: CricketColors.textGrey,
                  ),
                ),
              ),
              SizedBox(
                width: 28,
                child: Text(
                  'M',
                  textAlign: TextAlign.center,
                  style: _lightBold.copyWith(
                    fontSize: 12,
                    color: CricketColors.textGrey,
                  ),
                ),
              ),
              SizedBox(
                width: 32,
                child: Text(
                  'R',
                  textAlign: TextAlign.center,
                  style: _lightBold.copyWith(
                    fontSize: 12,
                    color: CricketColors.textGrey,
                  ),
                ),
              ),
              SizedBox(
                width: 28,
                child: Text(
                  'W',
                  textAlign: TextAlign.center,
                  style: _lightBold.copyWith(
                    fontSize: 12,
                    color: CricketColors.textGrey,
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  'Eco',
                  textAlign: TextAlign.center,
                  style: _lightBold.copyWith(
                    fontSize: 12,
                    color: CricketColors.textGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        ...bowling.map((e) => _buildBowlingRow(e)),
      ],
    );
  }

  Widget _buildBowlingRow(BowlingEntryModel e) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              e.bowler.name,
              style: _lightText.copyWith(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 32,
            child: Text(
              '${e.o}',
              textAlign: TextAlign.center,
              style: _lightText.copyWith(fontSize: 13),
            ),
          ),
          SizedBox(
            width: 28,
            child: Text(
              '${e.m}',
              textAlign: TextAlign.center,
              style: _lightText.copyWith(fontSize: 13),
            ),
          ),
          SizedBox(
            width: 32,
            child: Text(
              '${e.r}',
              textAlign: TextAlign.center,
              style: _lightText.copyWith(fontSize: 13),
            ),
          ),
          SizedBox(
            width: 28,
            child: Text(
              '${e.w}',
              textAlign: TextAlign.center,
              style: _lightText.copyWith(fontSize: 13),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              e.eco.toStringAsFixed(1),
              textAlign: TextAlign.center,
              style: _lightText.copyWith(fontSize: 13),
            ),
          ),
        ],
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
