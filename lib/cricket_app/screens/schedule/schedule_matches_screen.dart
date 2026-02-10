import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../constants/cricket_colors.dart';
import '../../constants/cricket_text_styles.dart';
import '../../data/models/match_model.dart';
import '../../data/repositories/providers/cricket_repository_provider.dart';
import '../../widgets/live_match_card.dart';
import '../../utils/error_handler_util.dart';
import '../match_center/upcoming_match_details_screen.dart';

/// Screen that shows upcoming matches filtered by schedule category
/// (International, T20, T10, Domestic, Women).
/// Uses the same data source as the Upcoming Matches screen.
class ScheduleMatchesScreen extends ConsumerStatefulWidget {
  final String category;

  const ScheduleMatchesScreen({super.key, required this.category});

  @override
  ConsumerState<ScheduleMatchesScreen> createState() =>
      _ScheduleMatchesScreenState();
}

class _ScheduleMatchesScreenState
    extends ConsumerState<ScheduleMatchesScreen> {
  List<MatchModel> _matches = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchMatches();
  }

  /// Checks if a match belongs to the selected category.
  bool _matchesCategory(MatchModel m) {
    final matchType = m.matchType.toLowerCase();
    final matchName = m.name.toLowerCase();

    switch (widget.category) {
      case 'International':
        return matchType == 'odi' ||
            matchType == 'test' ||
            matchName.contains('international') ||
            matchName.contains('icc') ||
            matchName.contains('world cup') ||
            matchName.contains('champions trophy');
      case 'T20':
        return matchType == 't20';
      case 'T10':
        return matchType == 't10' ||
            matchName.contains('t10') ||
            matchName.contains('abu dhabi t10');
      case 'Domestic':
        return matchName.contains('domestic') ||
            matchName.contains('league') ||
            matchName.contains('premier') ||
            matchName.contains('trophy') ||
            matchName.contains('cup') ||
            matchName.contains('ipl') ||
            matchName.contains('bbl') ||
            matchName.contains('psl') ||
            matchName.contains('cpl') ||
            matchName.contains('sa20') ||
            matchName.contains('bpl') ||
            matchName.contains('lpl') ||
            matchName.contains('hundred') ||
            matchName.contains('legends');
      case 'Women':
        return matchName.contains('women') ||
            matchName.contains("women's") ||
            matchName.contains('wpl') ||
            matchName.contains('wbbl') ||
            matchName.contains('womens');
      default:
        return true;
    }
  }

  Future<void> _fetchMatches() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = ref.read(cricketRepositoryProvider);

      // Use the same data source as the Upcoming Matches screen
      final response = await repository.getUpcomingMatches();

      // Apply category filter on top of upcoming matches
      final filtered = response.data.where(_matchesCategory).toList();

      debugPrint(
        'Schedule: ${widget.category} — '
        '${response.data.length} upcoming total, '
        '${filtered.length} after category filter',
      );

      setState(() {
        _matches = filtered;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching schedule matches: $e');
      setState(() {
        _error = ErrorHandlerUtil.getErrorMessage(e);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CricketColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: CricketColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: CricketColors.textBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${widget.category} Schedule',
          style: CricketTextStyles.headlineMedium.copyWith(
            color: CricketColors.textBlack,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: CricketColors.primaryBlue),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CricketColors.accentRed.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 48,
                  color: CricketColors.accentRed,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Oops! Something went wrong',
                style: CricketTextStyles.headlineSmall.copyWith(
                  color: CricketColors.textBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _error!,
                style: CricketTextStyles.bodyMedium.copyWith(
                  color: CricketColors.textGrey,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _fetchMatches,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CricketColors.primaryBlue,
                  foregroundColor: CricketColors.backgroundWhite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_matches.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event,
                size: 64,
                color: CricketColors.textGrey.withOpacity(0.4),
              ),
              const SizedBox(height: 16),
              Text(
                'No matches',
                style: CricketTextStyles.headlineSmall.copyWith(
                  color: CricketColors.textGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'No upcoming ${widget.category.toLowerCase()} matches scheduled',
                style: CricketTextStyles.bodyMedium.copyWith(
                  color: CricketColors.textGrey.withOpacity(0.7),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchMatches,
      color: CricketColors.primaryBlue,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _matches.length,
        itemBuilder: (context, index) {
          final match = _matches[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: LiveMatchCard(
              match: match,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UpcomingMatchDetailsScreen(match: match),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
