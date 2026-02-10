import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../constants/cricket_colors.dart';
import '../../constants/cricket_text_styles.dart';
import '../../widgets/live_match_card.dart';
import '../../providers/matches_provider.dart';
import '../../utils/error_handler_util.dart';
import '../match_center/completed_match_details_screen.dart';
import '../match_center/live_match_details_screen.dart';
import '../match_center/upcoming_match_details_screen.dart';
import '../../shared/services/cricket_ad_service.dart';

/// Screen that shows match list for a given type.
/// Live Matches uses eCricScore + currentMatches and shows Live + Completed sections.
class MatchesListScreen extends ConsumerStatefulWidget {
  final MatchFilterType filterType;
  final String title;

  const MatchesListScreen({
    super.key,
    required this.filterType,
    required this.title,
  });

  @override
  ConsumerState<MatchesListScreen> createState() => _MatchesListScreenState();
}

class _MatchesListScreenState extends ConsumerState<MatchesListScreen> {
  Object? _previousError;
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;
  bool _hasSetFilter = false;

  @override
  void initState() {
    super.initState();
    CricketAdService.incrementScreenView();
    CricketAdService.preloadInterstitialAd();
    _previousError = null;

    if (widget.filterType != MatchFilterType.live) {
      _scrollController.addListener(_onScroll);
      // Set filter immediately and synchronously before first build
      _setInitialFilter();
    }
  }

  void _setInitialFilter() {
    if (_hasSetFilter) return;
    _hasSetFilter = true;

    // Set filter synchronously to avoid showing wrong data on first load
    final notifier = ref.read(matchesNotifierProvider.notifier);
    if (notifier.currentFilter != widget.filterType) {
      notifier.changeFilter(widget.filterType);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MatchesListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filterType != widget.filterType) {
      _previousError = null;
      _hasSetFilter = false; // Reset flag when filter type changes
      if (widget.filterType != MatchFilterType.live) {
        ref
            .read(matchesNotifierProvider.notifier)
            .changeFilter(widget.filterType);
      }
    }
  }

  Future<void> _onRefreshTap() async {
    if (_isRefreshing || !mounted) return;
    setState(() => _isRefreshing = true);
    _previousError = null;
    try {
      if (widget.filterType == MatchFilterType.live) {
        await ref.read(currentMatchesNotifierProvider.notifier).refresh();
      } else {
        await ref.read(matchesNotifierProvider.notifier).refresh();
      }
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(matchesNotifierProvider.notifier).loadMore();
    }
  }

  void _showErrorSnackBar(Object error) {
    final errorString = error.toString();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _previousError.toString() != errorString) {
        _previousError = error;
        try {
          ErrorHandlerUtil.showErrorSnackBar(context, error);
        } catch (e) {
          debugPrint('Failed to show error snackbar: $e');
        }
      }
    });
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
          widget.title,
          style: CricketTextStyles.headlineMedium.copyWith(
            color: CricketColors.textBlack,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: _isRefreshing
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: CricketColors.primaryBlue,
                    ),
                  )
                : Icon(Icons.refresh, color: CricketColors.textBlack),
            onPressed: _isRefreshing ? null : _onRefreshTap,
          ),
        ],
      ),

      body: widget.filterType == MatchFilterType.live
          ? _buildLiveBody()
          : _buildDefaultBody(),
    );
  }

  // ─── Live matches body: ONLY Live section ───

  Widget _buildLiveBody() {
    final currentMatchesAsync = ref.watch(currentMatchesNotifierProvider);

    currentMatchesAsync.whenOrNull(
      error: (error, _) {
        if (_previousError != error) {
          _showErrorSnackBar(error);
        }
        return null;
      },
    );

    return currentMatchesAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: CricketColors.primaryBlue),
      ),
      error: (error, _) => _buildErrorWidget(),
      data: (data) {
        final liveMatches = data.liveMatches;
        if (liveMatches.isEmpty) return _buildEmptyStateLiveOnly();

        return RefreshIndicator(
          onRefresh: () {
            _previousError = null;
            return ref.read(currentMatchesNotifierProvider.notifier).refresh();
          },
          color: CricketColors.primaryBlue,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Live section ──
              _buildSectionHeader(
                title: 'Live',
                icon: Icons.circle,
                iconColor: Colors.red,
                iconSize: 10,
                count: liveMatches.length,
              ),
              const SizedBox(height: 12),
              ...liveMatches.map(
                (match) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: LiveMatchCard(
                    match: match,
                    onTap: () {
                      CricketAdService.showInterstitialAdIfNeeded(
                        screenName: 'matches_list_to_live_details',
                      ).then((_) {
                        if (mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  LiveMatchDetailsScreen(match: match),
                            ),
                          );
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required Color iconColor,
    required double iconSize,
    required int count,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: iconSize),
        const SizedBox(width: 8),
        Text(
          title,
          style: CricketTextStyles.headlineSmall.copyWith(
            color: CricketColors.textBlack,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: CricketColors.textGrey.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              color: CricketColors.textGrey,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Default body for non-live filter types ───

  Widget _buildDefaultBody() {
    final matchesAsync = ref.watch(matchesNotifierProvider);

    matchesAsync.whenOrNull(
      error: (error, _) {
        if (_previousError != error) {
          _showErrorSnackBar(error);
        }
        return null;
      },
    );

    return matchesAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: CricketColors.primaryBlue),
      ),
      error: (error, _) => _buildErrorWidget(),
      data: (response) {
        // Verify the data matches the expected filter to prevent showing wrong matches on first load
        final notifier = ref.read(matchesNotifierProvider.notifier);
        if (notifier.currentFilter != widget.filterType) {
          // Filter mismatch - still loading correct data, show loading indicator
          return const Center(
            child: CircularProgressIndicator(color: CricketColors.primaryBlue),
          );
        }

        final matches = response.data;
        if (matches.isEmpty) {
          return _buildEmptyState();
        }
        final showLoadingMore = notifier.hasMore;
        return RefreshIndicator(
          onRefresh: () {
            _previousError = null;
            return ref.read(matchesNotifierProvider.notifier).refresh();
          },
          color: CricketColors.primaryBlue,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: matches.length + (showLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              // Loading indicator at the bottom
              if (index == matches.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: CricketColors.primaryBlue,
                      ),
                    ),
                  ),
                );
              }
              final match = matches[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: LiveMatchCard(
                  match: match,
                  isCompleted: widget.filterType == MatchFilterType.finished,
                  onTap: () {
                    CricketAdService.showInterstitialAdIfNeeded(
                      screenName:
                          'matches_list_to_details_${widget.filterType.name}',
                    ).then((_) {
                      if (mounted) {
                        Widget detailScreen;
                        if (widget.filterType == MatchFilterType.finished ||
                            match.matchEnded) {
                          detailScreen = CompletedMatchDetailsScreen(
                            match: match,
                          );
                        } else if (match.matchStarted) {
                          detailScreen = LiveMatchDetailsScreen(match: match);
                        } else {
                          detailScreen = UpcomingMatchDetailsScreen(
                            match: match,
                          );
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => detailScreen),
                        );
                      }
                    });
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ─── Shared widgets ───

  Widget _buildErrorWidget() {
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
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _previousError = null;
                if (widget.filterType == MatchFilterType.live) {
                  ref.read(currentMatchesNotifierProvider.notifier).refresh();
                } else {
                  ref.read(matchesNotifierProvider.notifier).refresh();
                }
              },
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.filterType == MatchFilterType.finished
                  ? Icons.history
                  : widget.filterType == MatchFilterType.live
                  ? Icons.live_tv
                  : Icons.event,
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
              widget.filterType == MatchFilterType.finished
                  ? 'No completed matches available'
                  : widget.filterType == MatchFilterType.live
                  ? 'No live matches at the moment'
                  : 'No upcoming matches scheduled',
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

  Widget _buildEmptyStateLiveOnly() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.live_tv,
              size: 64,
              color: CricketColors.textGrey.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No live matches',
              style: CricketTextStyles.headlineSmall.copyWith(
                color: CricketColors.textGrey,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No live matches at the moment.\nCheck Completed Matches for results.',
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
}
