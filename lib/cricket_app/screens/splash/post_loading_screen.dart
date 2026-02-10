import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/cricket_colors.dart';
import '../../constants/cricket_text_styles.dart';
import '../../shared/services/cricket_ad_service.dart';
import '../home/cricket_home_screen.dart';

/// Post Loading Screen
/// Shows live_cricket_image2.png with text above the image
/// This screen appears after initial loading completes
class PostLoadingScreen extends StatefulWidget {
  const PostLoadingScreen({super.key});

  @override
  State<PostLoadingScreen> createState() => _PostLoadingScreenState();
}

class _PostLoadingScreenState extends State<PostLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  static const _telegramUrl = 'https://t.me/cricketscorelive1';
  static const String _androidPackageName = 'com.aryatech.cricketlivescore';
  static const String _iosAppId = '6739782344';

  @override
  void initState() {
    super.initState();

    // Initialize fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _fadeController.forward();

    // Navigate to onboarding after some time (commented out for now)
    // Future.delayed(const Duration(seconds: 5), () {
    //   if (mounted) {
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(
    //         builder: (context) => const OnboardingFlow(),
    //       ),
    //     );
    //   }
    // });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    // Show interstitial ad before navigating (if enabled)
    CricketAdService.showInterstitialAdIfNeeded(screenName: 'post_loading_to_home').then((_) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const CricketHomeScreen()),
        );
      }
    });
  }

  Future<void> _rateApp() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final playStoreAppUri = Uri.parse(
          'market://details?id=$_androidPackageName',
        );
        final playStoreWebUri = Uri.parse(
          'https://play.google.com/store/apps/details?id=$_androidPackageName',
        );

        if (await canLaunchUrl(playStoreAppUri)) {
          await launchUrl(
            playStoreAppUri,
            mode: LaunchMode.externalApplication,
          );
        } else {
          await launchUrl(
            playStoreWebUri,
            mode: LaunchMode.externalApplication,
          );
        }
        return;
      }

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final appStoreAppUri = Uri.parse(
          'itms-apps://itunes.apple.com/app/id$_iosAppId',
        );
        final appStoreWebUri = Uri.parse(
          'https://apps.apple.com/app/id$_iosAppId',
        );

        final ok = await launchUrl(
          appStoreAppUri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
        if (!ok) {
          await launchUrl(appStoreWebUri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open store: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _shareApp() async {
    try {
      final url =
          defaultTargetPlatform == TargetPlatform.iOS
              ? 'https://apps.apple.com/app/id$_iosAppId'
              : 'https://play.google.com/store/apps/details?id=$_androidPackageName';

      final shareText = 'Check out this app!\n\n$url';

      // iPad requires an anchor for the share sheet.
      final renderObject = context.findRenderObject();
      final box = renderObject is RenderBox ? renderObject : null;
      final origin =
          box != null ? (box.localToGlobal(Offset.zero) & box.size) : null;

      await Share.share(
        shareText,
        subject: 'Cricket Live Score',
        sharePositionOrigin: origin,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not share the app: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openPrivacyPolicy() async {
    try {
      final Uri url = Uri.parse(
        'https://sites.google.com/view/crictv-privacy-policy/home',
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open URL: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openTelegram() async {
    try {
      final Uri url = Uri.parse(_telegramUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open Telegram: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Text section above the image
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 40.0,
                ),
                child: Column(
                  children: [
                    Text(
                      'Welcome to',
                      style: CricketTextStyles.bodyMedium.copyWith(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        text: 'LIVE ',
                        style: CricketTextStyles.headlineLarge.copyWith(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: CricketColors.accentRed,
                        ),
                        children: [
                          TextSpan(
                            text: 'CRICKET',
                            style: CricketTextStyles.headlineLarge.copyWith(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Get real-time cricket scores, match updates, and live commentary',
                      style: CricketTextStyles.bodyMedium.copyWith(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Image section
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Image.asset(
                      'assets/cricket_app/images/live_cricket_image2.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.sports_cricket,
                                  size: 120,
                                  color: CricketColors.accentRed,
                                ),

                                Text(
                                  'Image not found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Buttons grid (2x2) at the bottom
              Padding(
                // Move buttons closer to image, keep extra space at bottom.
                padding: const EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  top: 0.0,
                  bottom: 80.0,
                ),
                child: Column(
                  children: [
                    // Android-only: Join Telegram (tap to open)
                    if (isAndroid) ...[
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _openTelegram,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 74, 118, 238),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 4,
                            shadowColor: CricketColors.primaryBlue.withOpacity(
                              0.35,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Join Telegram',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.send_rounded, size: 22),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    // Android: only Start button (keep UI same)
                    if (isAndroid) ...[
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _navigateToHome,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CricketColors.accentRed,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 4,
                            shadowColor: CricketColors.accentRed.withOpacity(
                              0.4,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Start',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, size: 22),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      // iOS: Start/Rate/Share/Privacy
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              'Start',
                              Icons.arrow_forward,
                              _navigateToHome,
                              isStart: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              'Rate',
                              Icons.star_outline,
                              _rateApp,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              'Share',
                              Icons.share_outlined,
                              _shareApp,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              'Privacy',
                              Icons.privacy_tip_outlined,
                              _openPrivacyPolicy,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              // Small banner ad below Start button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: CricketAdService.getSmallBannerAdWidget(padding: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed, {
    bool isStart = false,
  }) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 2,
          shadowColor: Colors.grey.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              size: 20,
              color: isStart
                  ? CricketColors.accentRed
                  : (label == 'Rate'
                        ? Colors.orange
                        : label == 'Share'
                        ? Colors.blue
                        : Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
