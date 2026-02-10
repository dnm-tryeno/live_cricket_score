import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_project/cricket_app/screens/splash/post_loading_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../constants/cricket_ad_constants.dart';
import '../../constants/cricket_colors.dart';
import '../../constants/cricket_text_styles.dart';
import '../matches/all_matches_screen.dart';
import '../schedule/schedule_screen.dart';
import '../point_table/point_table_screen.dart';
import '../settings/settings_screen.dart';
import '../../shared/services/cricket_ad_service.dart';

/// Cricket Home Screen
/// Shows featured matches, series coverage, and navigation
class CricketHomeScreen extends ConsumerStatefulWidget {
  const CricketHomeScreen({super.key});

  @override
  ConsumerState<CricketHomeScreen> createState() => _CricketHomeScreenState();
}

class _CricketHomeScreenState extends ConsumerState<CricketHomeScreen> {
  // Demo ad UI removed; keep empty space in the same place (Android + iOS).
  static const double _demoAdPlaceholderHeight = CricketAdConstants.adHeight;

  @override
  void initState() {
    super.initState();
    CricketAdService.incrementScreenView();
    // Preload interstitial ad for future use
    CricketAdService.preloadInterstitialAd();
    // No matches API on home — only when user taps Live Matches in All Matches
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CricketColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: CricketColors.backgroundWhite,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: CricketColors.textBlack),
          onPressed: () {
            final nav = Navigator.of(context);
            if (nav.canPop()) {
              nav.pop();
              return;
            }

            // CricketHomeScreen is usually opened with pushReplacement,
            // so there is no previous route to pop. Go back to tutorial.
            nav.pushReplacement(
              MaterialPageRoute(
                builder: (context) => const PostLoadingScreen(),
              ),
            );
          },
        ),
        title: Text(
          'Live Cricket',
          style: CricketTextStyles.headlineMedium.copyWith(
            color: CricketColors.textBlack,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (defaultTargetPlatform == TargetPlatform.android)
            IconButton(
              icon: Icon(
                Icons.settings_outlined,
                color: CricketColors.textBlack,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
        ],
      ),
      body: _buildBodyContent(),
    );
  }

  Widget _buildBodyContent() {
    // Home: light theme — Ad card, 3 buttons, Top News (image layout)
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _buildAdCard(),
          const SizedBox(height: 24),
          _buildFeatureButtons(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAdCard() {
    // Show native ad for both Android and iOS
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Container(
        width: double.infinity,
        height: _demoAdPlaceholderHeight,
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
              height: CricketAdConstants.adHeight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildFeatureButton('All Matches', Icons.sports_cricket, () {
            CricketAdService.showInterstitialAdIfNeeded(
              screenName: 'home_to_all_matches',
            ).then((_) {
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllMatchesScreen(),
                  ),
                );
              }
            });
          }),
          _buildFeatureButton('Schedule', Icons.schedule, () {
            CricketAdService.showInterstitialAdIfNeeded(
              screenName: 'home_to_schedule',
            ).then((_) {
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScheduleScreen(),
                  ),
                );
              }
            });
          }),
          _buildFeatureButton('Point Table', Icons.table_chart, () {
            CricketAdService.showInterstitialAdIfNeeded(
              screenName: 'home_to_point_table',
            ).then((_) {
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PointTableScreen(),
                  ),
                );
              }
            });
          }),
        ],
      ),
    );
  }

  Widget _buildFeatureButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
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
        child: Column(
          children: [
            Icon(icon, size: 36, color: CricketColors.textBlack),
            const SizedBox(height: 8),
            Text(
              label,
              style: CricketTextStyles.bodyMedium.copyWith(
                color: CricketColors.textBlack,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Top News card removed as requested.
}
