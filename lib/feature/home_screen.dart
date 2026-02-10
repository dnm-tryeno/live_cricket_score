import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_project/feature/constants/app_colors.dart';
import 'package:flutter_project/feature/constants/app_strings.dart';
import 'package:flutter_project/feature/shared/navigation/app_router.gr.dart';
import 'package:flutter_project/feature/shared/services/app_update_service.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedBasicOption;

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  void _checkForUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1500), () async {
        if (mounted && context.mounted) {
          await AppUpdateService.checkForUpdate(context);
        }
      });
    });
  }

  void _pickImage(ImageSource source) {
    // Navigate to intermediate image picker page
    // This prevents home screen from being visible after camera closes
    context.router
        .push(
          ImagePickerRoute(
            source: source,
            backgroundOption: _selectedBasicOption,
          ),
        )
        .then((_) {
          // Reset selection when coming back from image picker flow
          if (mounted && _selectedBasicOption != null) {
            setState(() {
              _selectedBasicOption = null;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          AppStrings.appName,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildImagePreview(),
            const SizedBox(height: 20),
            _buildActionButtons(),
            const SizedBox(height: 30),
            _buildBasicsSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primaryCoral),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.image, size: 60, color: Colors.white),
                const SizedBox(height: 10),
                const Text(
                  AppStrings.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Join Telegram
          if (Platform.isAndroid)
            _buildDrawerNavigationOption(
              Icons.send,
              'Join Telegram',
              iconColor: const Color(0xFF0088CC),
              onTap: () {
                Navigator.pop(context);
                _openTelegram();
              },
            ),
          if (Platform.isAndroid) const Divider(height: 1),
          // Privacy Policy
          _buildDrawerNavigationOption(
            Icons.privacy_tip,
            AppStrings.privacyPolicy,
            onTap: () {
              Navigator.pop(context);
              _openUrl(
                'https://sites.google.com/view/bg-remover-privacy-policy-/home',
              );
            },
          ),
          const Divider(height: 1),
          // Terms and Conditions
          _buildDrawerNavigationOption(
            Icons.description,
            AppStrings.termsAndConditions,
            onTap: () {
              Navigator.pop(context);
              _openUrl(
                'https://sites.google.com/view/bg-remover-terms-of-use/',
              );
            },
          ),
          const Divider(height: 1),
          // Rate Us
          _buildDrawerNavigationOption(
            Icons.star,
            AppStrings.rateUs,
            onTap: () {
              Navigator.pop(context);
              _openAppStore();
            },
          ),
          const Divider(height: 1),
          // Share App
          _buildDrawerNavigationOption(
            Icons.share,
            AppStrings.shareApp,
            onTap: () {
              Navigator.pop(context);
              _shareApp();
            },
          ),
          const Divider(height: 1),
          // Contact Us
          _buildDrawerNavigationOption(
            Icons.email,
            AppStrings.contactUs,
            subtitle: Platform.isIOS
                ? 'removerbgofficial@gmail.com'
                : 'bgremoveofficial@gmail.com',
            onTap: () {
              Navigator.pop(context);
              _openEmailClient(
                Platform.isIOS
                    ? 'removerbgofficial@gmail.com'
                    : 'bgremoveofficial@gmail.com',
              );
            },
          ),
          const SizedBox(height: 20),
          // Version
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: Text(
          //     AppStrings.version,
          //     style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerNavigationOption(
    IconData icon,
    String title, {
    String? subtitle,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    final color = iconColor ?? AppColors.primaryCoral;
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            )
          : null,
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }

  Widget _buildImagePreview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 80,
            color: AppColors.primaryCoral.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 20),
          const Text(
            AppStrings.noImageSelected,
            style: TextStyle(
              color: AppColors.primaryCoral,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              AppStrings.choosePhotoHint,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildButton(
            AppStrings.uploadPhoto,
            Icons.image,
            AppColors.primaryCoral,
            Colors.white,
            () => _pickImage(ImageSource.gallery),
          ),
          const SizedBox(height: 12),
          _buildButton(
            AppStrings.takePhoto,
            Icons.camera_alt,
            AppColors.buttonSecondary,
            AppColors.primaryCoral,
            () => _pickImage(ImageSource.camera),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String text,
    IconData icon,
    Color bgColor,
    Color textColor,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: textColor),
        label: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildBasicsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppStrings.basics,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildBasicOption(
                'Transparent',
                'assets/backgrounds/transparent_image.png',
                hasCheckboard: true,
                isSelected: _selectedBasicOption == 'Transparent',
                onTap: () => _handleBasicOptionTap('Transparent'),
              ),
              _buildBasicOption(
                'White',
                'assets/backgrounds/white_image.png',
                isSelected: _selectedBasicOption == 'White',
                onTap: () => _handleBasicOptionTap('White'),
              ),
              _buildBasicOption(
                'Black',
                'assets/backgrounds/black_image.png',
                isSelected: _selectedBasicOption == 'Black',
                onTap: () => _handleBasicOptionTap('Black'),
              ),
              _buildBasicOption(
                'Blur',
                'assets/backgrounds/blur.png',
                isSelected: _selectedBasicOption == 'Blur',
                onTap: () => _handleBasicOptionTap('Blur'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleBasicOptionTap(String option) async {
    // Update selected option for visual feedback
    setState(() {
      // Toggle selection - if same option clicked, deselect it
      if (_selectedBasicOption == option) {
        _selectedBasicOption = null;
      } else {
        _selectedBasicOption = option;
      }
    });

    // Show message to upload photo after selecting option
    if (_selectedBasicOption != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$option selected. Now upload a photo to continue.'),
          backgroundColor: AppColors.primaryCoral,
          duration: const Duration(seconds: 2),
        ),
      );
    }
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

  Future<void> _openEmailClient(String email) async {
    try {
      final String subject = Uri.encodeComponent(
        'Background Remover App - Support',
      );
      final Uri emailUri = Uri.parse('mailto:$email?subject=$subject');

      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening email: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openTelegram() async {
    try {
      // Open Telegram channel - will open in app if installed, otherwise in browser
      final telegramUri = Uri.parse('https://t.me/bgremoveofficial');
      
      if (await canLaunchUrl(telegramUri)) {
        await launchUrl(telegramUri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open Telegram'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening Telegram: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openAppStore() async {
    try {
      if (Platform.isAndroid) {
        // Android: Open Play Store
        final playStoreUri = Uri.parse(
          'market://details?id=com.aryatech.cricketlivescore',
        );
        final playStoreWebUri = Uri.parse(
          'https://play.google.com/store/apps/details?id=com.aryatech.cricketlivescore',
        );

        // Try market:// protocol first (opens Play Store app)
        if (await canLaunchUrl(playStoreUri)) {
          await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
        } else {
          // Fallback to web URL
          await launchUrl(playStoreWebUri, mode: LaunchMode.externalApplication);
        }
      } else if (Platform.isIOS) {
        // iOS: Open App Store
        // Try itms-apps:// protocol first (opens App Store app directly)
        final appStoreAppUri = Uri.parse(
          'itms-apps://apps.apple.com/app/id6739782344',
        );
        // Fallback to web URL
        final appStoreWebUri = Uri.parse(
          'https://apps.apple.com/app/id6739782344',
        );

        // Try itms-apps:// protocol first (opens App Store app)
        if (await canLaunchUrl(appStoreAppUri)) {
          await launchUrl(appStoreAppUri, mode: LaunchMode.externalApplication);
        } else {
          // Fallback to web URL
          await launchUrl(appStoreWebUri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening store: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _shareApp() async {
    try {
      String shareText;
      String shareUrl;

      if (Platform.isAndroid) {
        // Android: Share Play Store link
        shareUrl = 'https://play.google.com/store/apps/details?id=com.aryatech.cricketlivescore';
        shareText = 'Check out this amazing Background Remover app!\n\n$shareUrl';
      } else if (Platform.isIOS) {
        // iOS: Share App Store link
        shareUrl = 'https://apps.apple.com/app/id6739782344';
        shareText = 'Check out this amazing Background Remover app!\n\n$shareUrl';
      } else {
        return;
      }

      await Share.share(
        shareText,
        subject: 'Background Remover App',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing app: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildBasicOption(
    String label,
    String imagePath, {
    bool hasCheckboard = false,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryCoral
                      : Colors.grey.shade300,
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryCoral.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback UI if image fails to load
                    return Container(
                      color: label == 'White'
                          ? Colors.white
                          : label == 'Black'
                          ? Colors.black
                          : Colors.grey.shade200,
                      child: hasCheckboard
                          ? CustomPaint(painter: CheckerboardPainter())
                          : label == 'Blur'
                          ? Icon(
                              Icons.blur_on,
                              size: 40,
                              color: Colors.grey.shade600,
                            )
                          : null,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppColors.primaryCoral
                    : (label == 'Transparent'
                          ? AppColors.primaryCoral
                          : Colors.black),
                fontSize: 14,
                fontWeight: isSelected || label == 'Transparent'
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckerboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double squareSize = 8;
    final paint1 = Paint()..color = Colors.white;
    final paint2 = Paint()..color = Colors.grey.shade300;

    for (double i = 0; i < size.height; i += squareSize) {
      for (double j = 0; j < size.width; j += squareSize) {
        final isEven = ((i / squareSize) + (j / squareSize)) % 2 == 0;
        canvas.drawRect(
          Rect.fromLTWH(j, i, squareSize, squareSize),
          isEven ? paint1 : paint2,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
