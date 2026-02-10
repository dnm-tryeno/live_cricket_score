import 'package:flutter/material.dart';
import '../../constants/cricket_ad_constants.dart';
import '../../constants/cricket_colors.dart';
import '../../constants/cricket_text_styles.dart';
import '../../shared/services/cricket_ad_service.dart';
import 'schedule_matches_screen.dart';

/// Schedule Screen
/// Shows advertisement card and match type category buttons
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
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
          'Schedule',
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
            const SizedBox(height: 32),
            _buildCategoryGrid(),
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

  Widget _buildCategoryGrid() {
    final categories = [
      {'label': 'International', 'icon': Icons.access_time},
      {'label': 'T20', 'icon': Icons.access_time},
      {'label': 'T10', 'icon': Icons.access_time},
      {'label': 'Domestic', 'icon': Icons.access_time},
      {'label': 'Women', 'icon': Icons.access_time},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // First row: 3 buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCategoryButton(
                categories[0]['label'] as String,
                categories[0]['icon'] as IconData,
              ),
              const SizedBox(width: 16),
              _buildCategoryButton(
                categories[1]['label'] as String,
                categories[1]['icon'] as IconData,
              ),
              const SizedBox(width: 16),
              _buildCategoryButton(
                categories[2]['label'] as String,
                categories[2]['icon'] as IconData,
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Second row: 2 buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildCategoryButton(
                categories[3]['label'] as String,
                categories[3]['icon'] as IconData,
              ),
              const SizedBox(width: 16),
              _buildCategoryButton(
                categories[4]['label'] as String,
                categories[4]['icon'] as IconData,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String label, IconData icon) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          CricketAdService.showInterstitialAdIfNeeded(screenName: 'schedule_to_matches_$label').then((_) {
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ScheduleMatchesScreen(category: label),
                ),
              );
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
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
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Clock/Stopwatch icon centered
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: CricketColors.backgroundLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: CricketColors.textGrey.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: 24,
                        color: CricketColors.textBlack,
                      ),
                    ),
                    // Orange lines ABOVE the clock icon using Positioned
                    Positioned(
                      left: 5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 2,
                            decoration: BoxDecoration(
                              color: CricketColors.primaryOrange,
                              borderRadius: BorderRadius.circular(1.5),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            width: 8,
                            height: 2,
                            decoration: BoxDecoration(
                              color: CricketColors.primaryOrange,
                              borderRadius: BorderRadius.circular(1.5),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            width: 8,
                            height: 2,
                            decoration: BoxDecoration(
                              color: CricketColors.primaryOrange,
                              borderRadius: BorderRadius.circular(1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: CricketTextStyles.bodyMedium.copyWith(
                  color: CricketColors.textBlack,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
