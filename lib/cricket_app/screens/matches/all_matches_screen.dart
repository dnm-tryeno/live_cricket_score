import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../constants/cricket_ad_constants.dart';
import '../../constants/cricket_colors.dart';
import '../../constants/cricket_text_styles.dart';
import '../../shared/services/cricket_ad_service.dart';
import '../../providers/matches_provider.dart';
import 'matches_list_screen.dart';

/// All Matches Screen — image layout: Ad card + Completed / Live / Upcoming cards.
/// Live Matches tap → currentMatches API (via MatchesListScreen).
class AllMatchesScreen extends ConsumerStatefulWidget {
  const AllMatchesScreen({super.key});

  @override
  ConsumerState<AllMatchesScreen> createState() => _AllMatchesScreenState();
}

class _AllMatchesScreenState extends ConsumerState<AllMatchesScreen> {
  @override
  void initState() {
    super.initState();
    CricketAdService.incrementScreenView();
    CricketAdService.preloadInterstitialAd();
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
          'All Matches',
          style: CricketTextStyles.headlineMedium.copyWith(
            color: CricketColors.textBlack,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildAdCard(),
            const SizedBox(height: 20),
            _buildMatchTypeCard(
              title: 'Completed Matches',
              icon: Icons.history,
              onTap: () {
                CricketAdService.showInterstitialAdIfNeeded(
                  screenName: 'all_matches_to_completed',
                ).then((_) {
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MatchesListScreen(
                          filterType: MatchFilterType.finished,
                          title: 'Completed Matches',
                        ),
                      ),
                    );
                  }
                });
              },
            ),
            const SizedBox(height: 12),
            _buildMatchTypeCard(
              title: 'Live Matches',
              icon: Icons.live_tv,
              onTap: () {
                CricketAdService.showInterstitialAdIfNeeded(
                  screenName: 'all_matches_to_live',
                ).then((_) {
                  if (mounted) {
                    // currentMatches API is called when this screen loads
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MatchesListScreen(
                          filterType: MatchFilterType.live,
                          title: 'Live Matches',
                        ),
                      ),
                    );
                  }
                });
              },
            ),
            const SizedBox(height: 12),
            _buildMatchTypeCard(
              title: 'Upcoming Matches',
              icon: Icons.event,
              onTap: () {
                CricketAdService.showInterstitialAdIfNeeded(
                  screenName: 'all_matches_to_upcoming',
                ).then((_) {
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MatchesListScreen(
                          filterType: MatchFilterType.upcoming,
                          title: 'Upcoming Matches',
                        ),
                      ),
                    );
                  }
                });
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAdCard() {
    // Show native ad for both Android and iOS
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: CricketAdConstants.adHeight,
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

  Widget _buildMatchTypeCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CricketColors.backgroundWhite,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: CricketColors.primaryOrange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: CricketColors.primaryOrange, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: CricketTextStyles.headlineSmall.copyWith(
                    color: CricketColors.textBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: CricketColors.primaryOrange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
