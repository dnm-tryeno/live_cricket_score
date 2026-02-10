import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/cricket_colors.dart';
import '../../constants/cricket_text_styles.dart';

/// Settings Screen
/// Shows app settings and preferences
class SettingsScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const SettingsScreen({super.key, this.onBackPressed});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

  static const String _androidPackageName = 'com.aryatech.cricketlivescore';
  static const String _iosAppId = '6739782344';

  Future<void> _openUrl(String urlString) async {
    try {
      final uri = Uri.parse(urlString);
      final ok = await canLaunchUrl(uri);
      if (!ok) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open the URL'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      await launchUrl(uri, mode: LaunchMode.externalApplication);
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
      final url = defaultTargetPlatform == TargetPlatform.iOS
          ? 'https://apps.apple.com/app/id$_iosAppId'
          : 'https://play.google.com/store/apps/details?id=$_androidPackageName';

      final shareText = 'Check out this app!\n\n$url';

      // iPad requires an anchor for the share sheet.
      final renderObject = context.findRenderObject();
      final box = renderObject is RenderBox ? renderObject : null;
      final origin = box != null
          ? (box.localToGlobal(Offset.zero) & box.size)
          : null;

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
    await _openUrl(
      'https://sites.google.com/view/cricketlivescoreappshai/home',
    );
  }

  Future<void> _openTermsAndConditions() async {
    await _openUrl('https://sites.google.com/view/dhdfduyf/home');
  }

  @override
  void initState() {
    super.initState();
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
          onPressed: () {
            if (widget.onBackPressed != null) {
              widget.onBackPressed!();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          'Settings',
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
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildSettingsMenuItem(
                    'App Version',
                    '1.0.0',
                    Icons.info_outline,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  if (_isAndroid) ...[
                    _buildSettingsMenuItem(
                      'Rate Us',
                      '',
                      Icons.star_outline,
                      onTap: _rateApp,
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsMenuItem(
                      'Share App',
                      '',
                      Icons.share_outlined,
                      onTap: _shareApp,
                    ),
                    const SizedBox(height: 12),
                  ],
                  _buildSettingsMenuItem(
                    'Terms of Service',
                    '',
                    Icons.description_outlined,
                    onTap: _openTermsAndConditions,
                  ),
                  const SizedBox(height: 12),
                  _buildSettingsMenuItem(
                    'Privacy Policy',
                    '',
                    Icons.privacy_tip_outlined,
                    onTap: _openPrivacyPolicy,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsMenuItem(
    String title,
    String subtitle,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
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
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: CricketColors.primaryOrange, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: CricketTextStyles.bodyMedium.copyWith(
                      color: CricketColors.textBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: CricketTextStyles.bodySmall.copyWith(
                        color: CricketColors.textGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: CricketColors.textGrey.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}
