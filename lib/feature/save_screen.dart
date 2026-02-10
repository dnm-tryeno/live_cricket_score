import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter_project/feature/constants/app_colors.dart';
import 'package:flutter_project/feature/constants/app_strings.dart';

@RoutePage()
class SavePage extends StatefulWidget {
  final Uint8List processedImage;
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  final String? backgroundImage;
  final Uint8List? customBackgroundImage;
  final bool isBlurred;
  final double scale;
  final Offset offset;

  const SavePage({
    super.key,
    required this.processedImage,
    this.backgroundColor,
    this.gradientColors,
    this.backgroundImage,
    this.customBackgroundImage,
    this.isBlurred = false,
    this.scale = 1.0,
    this.offset = Offset.zero,
  });

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  String _selectedResolution = '1280×720';
  String _selectedQuality = 'Medium';
  bool _isSaving = false;
  bool _isSharing = false;
  final GlobalKey _repaintKey = GlobalKey();

  Future<void> _saveImage() async {
    setState(() {
      _isSaving = true;
    });

    try {
      // Capture the image with background
      final RenderRepaintBoundary boundary =
          _repaintKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final Uint8List imageBytes = byteData!.buffer.asUint8List();

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final file = await File(
        '${tempDir.path}/processed_${DateTime.now().millisecondsSinceEpoch}.png',
      ).create();
      await file.writeAsBytes(imageBytes);

      // Save to gallery
      await Gal.putImage(file.path);

      // Delete temporary file
      await file.delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image saved to gallery successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _shareImage() async {
    if (_isSharing || _isSaving) return;

    setState(() {
      _isSharing = true;
    });

    try {
      // Capture the image with background
      final RenderRepaintBoundary boundary =
          _repaintKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final Uint8List imageBytes = byteData!.buffer.asUint8List();

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${tempDir.path}/share_$timestamp.png';
      final file = File(filePath);

      // Ensure file is created and written
      await file.writeAsBytes(imageBytes);

      // Verify file exists before sharing
      if (!await file.exists()) {
        throw Exception('Failed to create image file for sharing');
      }

      // Share the image
      final result = await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Check out this edited image!');

      // Show success message if share was successful
      if (mounted && result.status == ShareResultStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image shared successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Delete temporary file after a delay to ensure sharing completes
      Future.delayed(const Duration(seconds: 3), () async {
        try {
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          // Ignore deletion errors
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing image: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          AppStrings.saveImage,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryCoral,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      AppStrings.save,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildPreview()),
          _buildQualityOptions(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: RepaintBoundary(
        key: _repaintKey,
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            gradient: widget.gradientColors != null
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.gradientColors!,
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Custom background image if uploaded
                if (widget.customBackgroundImage != null)
                  Positioned.fill(
                    child: widget.isBlurred
                        ? ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: 10,
                              sigmaY: 10,
                            ),
                            child: Image.memory(
                              widget.customBackgroundImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.memory(
                            widget.customBackgroundImage!,
                            fit: BoxFit.cover,
                          ),
                  ),

                // Background image if selected
                if (widget.backgroundImage != null &&
                    widget.customBackgroundImage == null)
                  Positioned.fill(
                    child: widget.isBlurred
                        ? ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: 10,
                              sigmaY: 10,
                            ),
                            child: Image.asset(
                              widget.backgroundImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(color: Colors.grey.shade300);
                              },
                            ),
                          )
                        : Image.asset(
                            widget.backgroundImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(color: Colors.grey.shade300);
                            },
                          ),
                  ),

                // Blurred solid color background
                if (widget.isBlurred &&
                    widget.backgroundColor != null &&
                    widget.backgroundImage == null &&
                    widget.customBackgroundImage == null)
                  Positioned.fill(
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(color: widget.backgroundColor),
                    ),
                  ),

                // Blurred transparent background (checkerboard)
                if (widget.isBlurred &&
                    widget.backgroundColor == null &&
                    widget.backgroundImage == null &&
                    widget.customBackgroundImage == null)
                  Positioned.fill(
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: CustomPaint(
                        painter: CheckerboardPainter(),
                        size: Size.infinite,
                      ),
                    ),
                  ),

                // Processed image with zoom/pan transforms
                Center(
                  child: Transform.translate(
                    offset: widget.offset,
                    child: Transform.scale(
                      scale: widget.scale,
                      child: Image.memory(
                        widget.processedImage,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        isAntiAlias: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQualityOptions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.chooseImageQuality,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Resolution options
          Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  AppStrings.fileType,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
              ),
              _buildResolutionOption('720×480'),
              const SizedBox(width: 12),
              _buildResolutionOption('1280×720'),
              const SizedBox(width: 12),
              _buildResolutionOption('1920×1080'),
            ],
          ),
          const SizedBox(height: 16),

          // Quality options
          Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  AppStrings.quality,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
              ),
              _buildQualityOption('Low'),
              const SizedBox(width: 12),
              _buildQualityOption('Medium'),
              const SizedBox(width: 12),
              _buildQualityOption('High'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResolutionOption(String resolution) {
    final isSelected = _selectedResolution == resolution;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedResolution = resolution;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryCoral : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              resolution,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQualityOption(String quality) {
    final isSelected = _selectedQuality == quality;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedQuality = quality;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryCoral : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              quality,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF00BCD4),
                borderRadius: BorderRadius.circular(30),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(Icons.home, color: Colors.white, size: 30),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryCoral,
                borderRadius: BorderRadius.circular(30),
              ),
              child: _isSharing
                  ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : IconButton(
                      onPressed: _isSaving ? null : _shareImage,
                      icon: const Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class CheckerboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double squareSize = 10;
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
