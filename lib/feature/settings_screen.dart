import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_project/feature/constants/app_colors.dart';
import 'package:flutter_project/feature/constants/app_strings.dart';

@RoutePage()
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          AppStrings.settings,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSettingsOptions(),
            const SizedBox(height: 40),
            _buildVersion(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOptions() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildToggleOption(Icons.dark_mode, AppStrings.darkMode, _darkMode, (
            value,
          ) {
            setState(() {
              _darkMode = value;
            });
          }),
          _buildDivider(),
          _buildNavigationOption(
            Icons.language,
            AppStrings.chooseLanguage,
            subtitle: AppStrings.english,
            onTap: () {
              // Language selection
            },
          ),
          _buildDivider(),
          _buildNavigationOption(
            Icons.privacy_tip,
            AppStrings.privacyPolicy,
            onTap: () {
              _openUrl(
                'https://sites.google.com/view/bg-remover-privacy-policy-/home',
              );
            },
          ),
          _buildDivider(),
          _buildNavigationOption(
            Icons.description,
            AppStrings.termsAndConditions,
            onTap: () {
              _openUrl(
                'https://sites.google.com/view/bg-remover-terms-of-use/',
              );
            },
          ),
          _buildDivider(),
          _buildNavigationOption(
            Icons.star,
            AppStrings.rateUs,
            onTap: () {
              // Rate us
            },
          ),
          _buildDivider(),
          _buildNavigationOption(
            Icons.share,
            AppStrings.shareApp,
            onTap: () {
              // Share app
            },
          ),
          _buildDivider(),
          _buildNavigationOption(
            Icons.apps,
            AppStrings.moreApps,
            onTap: () {
              // More apps
            },
          ),
          _buildDivider(),
          _buildNavigationOption(
            Icons.exit_to_app,
            AppStrings.exit,
            onTap: () {
              _showExitDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(
    IconData icon,
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryCoral.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primaryCoral),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primaryCoral,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationOption(
    IconData icon,
    String title, {
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryCoral.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primaryCoral),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 72, color: Colors.grey.shade200);
  }

  Widget _buildVersion() {
    return Text(
      AppStrings.version,
      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
    );
  }

  Future<void> _openUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open the URL'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening URL: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Exit app logic
              Navigator.pop(context);
            },
            child: const Text('Exit', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
