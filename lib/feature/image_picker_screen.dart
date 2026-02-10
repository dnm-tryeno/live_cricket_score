import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_project/feature/constants/app_colors.dart';
import 'package:flutter_project/feature/shared/navigation/app_router.gr.dart';

@RoutePage()
class ImagePickerPage extends StatefulWidget {
  final ImageSource source;
  final String? backgroundOption;

  const ImagePickerPage({
    super.key,
    required this.source,
    this.backgroundOption,
  });

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  final ImagePicker _picker = ImagePicker();
  bool _isNavigatingToScanning = false;

  @override
  void initState() {
    super.initState();
    // Automatically open camera/gallery when this page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pickImage();
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: widget.source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        // Update UI to show "Opening Scanning Page"
        setState(() {
          _isNavigatingToScanning = true;
        });

        // Small delay to show the message
        await Future.delayed(const Duration(milliseconds: 5));

        final imageFile = File(image.path);

        // Navigate to processing screen - replaces this intermediate screen
        if (mounted) {
          if (widget.backgroundOption != null) {
            context.router.replace(
              ProcessingRoute(
                imageFile: imageFile,
                backgroundOption: widget.backgroundOption,
              ),
            );
          } else {
            context.router.replace(ProcessingRoute(imageFile: imageFile));
          }
        }
      } else {
        // User cancelled - go back to home screen
        if (mounted) {
          context.router.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        // Show error and go back
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
        context.router.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show appropriate loading screen based on state
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppColors.primaryCoral,
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              _isNavigatingToScanning
                  ? 'Opening Scanning Page...'
                  : (widget.source == ImageSource.camera
                        ? 'Opening Camera...'
                        : 'Opening Gallery...'),
              style: const TextStyle(
                color: AppColors.primaryCoral,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
