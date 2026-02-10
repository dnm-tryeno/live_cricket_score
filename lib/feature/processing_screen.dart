import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_background_remover/image_background_remover.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_project/feature/constants/app_colors.dart';
import 'package:flutter_project/feature/constants/app_strings.dart';
import 'package:flutter_project/feature/shared/navigation/app_router.gr.dart';

/// Top-level function for isolate execution
/// Minimal post-processing to preserve image quality
Future<Uint8List> _enhanceAndCleanupEdgesIsolate(Uint8List imageBytes) async {
  try {
    // Decode image
    final image = img.decodeImage(imageBytes);
    if (image == null) return imageBytes;

    // Just do minimal cleanup - remove almost fully transparent pixels
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final alpha = pixel.a;

        // Only remove almost completely transparent pixels (artifacts)
        if (alpha > 0 && alpha < 5) {
          image.setPixel(x, y, img.ColorRgba8(0, 0, 0, 0));
        }
      }
    }

    // Auto-crop with padding
    final cropped = _autoCropInIsolate(image);

    // Encode with maximum quality to preserve image sharpness
    return Uint8List.fromList(img.encodePng(cropped, level: 9));
  } catch (e) {
    return imageBytes;
  }
}

/// Auto-crop helper for isolate
img.Image _autoCropInIsolate(img.Image image) {
  try {
    int minX = image.width;
    int minY = image.height;
    int maxX = 0;
    int maxY = 0;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        if (pixel.a > 10) {
          if (x < minX) minX = x;
          if (x > maxX) maxX = x;
          if (y < minY) minY = y;
          if (y > maxY) maxY = y;
        }
      }
    }

    final paddingX = ((maxX - minX) * 0.02).round();
    final paddingY = ((maxY - minY) * 0.02).round();

    minX = (minX - paddingX).clamp(0, image.width - 1);
    minY = (minY - paddingY).clamp(0, image.height - 1);
    maxX = (maxX + paddingX).clamp(0, image.width - 1);
    maxY = (maxY + paddingY).clamp(0, image.height - 1);

    final cropWidth = maxX - minX + 1;
    final cropHeight = maxY - minY + 1;

    if (cropWidth < image.width * 0.95 || cropHeight < image.height * 0.95) {
      return img.copyCrop(
        image,
        x: minX,
        y: minY,
        width: cropWidth,
        height: cropHeight,
      );
    }

    return image;
  } catch (e) {
    return image;
  }
}

@RoutePage()
class ProcessingPage extends StatefulWidget {
  final File imageFile;
  final String? backgroundOption;

  const ProcessingPage({
    super.key,
    required this.imageFile,
    this.backgroundOption,
  });

  @override
  State<ProcessingPage> createState() => _ProcessingPageState();
}

class _ProcessingPageState extends State<ProcessingPage>
    with SingleTickerProviderStateMixin {
  bool _isProcessing = true;
  Uint8List? _processedImage;
  Uint8List? _imageBytes; // Store image bytes for display
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    // Initialize ONNX runtime ONCE (singleton pattern)
    // This prevents repeated session creation/destruction which causes memory spikes
    _initializeOnnxOnce();

    _processImage();
  }

  /// Initialize ONNX session only once (singleton)
  /// Prevents memory leaks from repeated session creation
  Future<void> _initializeOnnxOnce() async {
    try {
      // Only initialize if not already initialized
      // The BackgroundRemover instance manages its own lifecycle
      await BackgroundRemover.instance.initializeOrt();
    } catch (e) {
      if (kDebugMode) {
        print('ONNX already initialized or error: $e');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    // DO NOT dispose ONNX here - it should be reused across screens
    // ONNX will be disposed when the app closes (in main app lifecycle)
    super.dispose();
  }

  /// Resize large images to prevent memory issues
  Future<Uint8List> _resizeImageIfNeeded(Uint8List imageBytes) async {
    try {
      // Decode the image to check dimensions
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      if (kDebugMode) {
        print('Original image dimensions: ${image.width}x${image.height}');
      }

      // Max dimension for processing - optimized for mobile ONNX stability
      // Lower resolution prevents memory crashes on low-RAM devices
      const int maxDimension = 1024;

      // If image is within acceptable size, return as-is
      if (image.width <= maxDimension && image.height <= maxDimension) {
        if (kDebugMode) {
          print('Image size acceptable, no resizing needed');
        }
        return imageBytes;
      }

      // Calculate new dimensions maintaining aspect ratio
      int newWidth, newHeight;
      if (image.width > image.height) {
        newWidth = maxDimension;
        newHeight = (image.height * maxDimension / image.width).round();
      } else {
        newHeight = maxDimension;
        newWidth = (image.width * maxDimension / image.height).round();
      }

      if (kDebugMode) {
        print('Resizing image to: ${newWidth}x${newHeight}');
      }

      // Resize with high-quality cubic interpolation for better edges
      final resized = img.copyResize(
        image,
        width: newWidth,
        height: newHeight,
        interpolation: img.Interpolation.cubic,
      );

      // Encode back to PNG with high quality
      final resizedBytes = Uint8List.fromList(img.encodePng(resized, level: 6));

      if (kDebugMode) {
        print('Resized image size: ${resizedBytes.length} bytes');
      }

      return resizedBytes;
    } catch (e) {
      if (kDebugMode) {
        print('Error resizing image: $e');
      }
      rethrow;
    }
  }

  Future<void> _processImage() async {
    try {
      // Simulate processing delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));

      // Read image as bytes
      final rawImageBytes = await widget.imageFile.readAsBytes();

      if (kDebugMode) {
        print('Raw image size: ${rawImageBytes.length} bytes');
      }

      // Resize image if needed to prevent memory issues
      final imageBytes = await _resizeImageIfNeeded(rawImageBytes);

      // Store image bytes for display
      if (mounted) {
        setState(() {
          _imageBytes = imageBytes;
        });
      }

      try {
        // Use professional background removal with ONNX
        if (kDebugMode) {
          print('Starting professional background removal process...');
          print('Processing image size: ${imageBytes.length} bytes');
        }

        // Remove background with optimal settings
        // Lower threshold = more aggressive removal
        final ui.Image resultImage = await BackgroundRemover.instance.removeBg(
          imageBytes,
          threshold: 0.2, // Lower threshold for better background removal
          smoothMask: true, // Smooth edges for natural look
          enhanceEdges: true, // Enhance edge quality
        );

        // Convert ui.Image to Uint8List
        final ByteData? byteData = await resultImage.toByteData(
          format: ui.ImageByteFormat.png,
        );

        if (byteData != null) {
          // Enhance and clean up edges for better clarity
          // Run in separate isolate to prevent UI freezing
          final rawImage = byteData.buffer.asUint8List();

          if (kDebugMode) {
            print('Running minimal post-processing in background isolate...');
            print('Image size before processing: ${rawImage.length} bytes');
          }

          // Use compute to run minimal processing in isolate (off main thread)
          // Only does cleanup and auto-crop to preserve image quality
          final processedImageBytes = await compute(_enhanceAndCleanupEdgesIsolate, rawImage);

          if (kDebugMode) {
            print('Image size after processing: ${processedImageBytes.length} bytes');
          }

          if (kDebugMode) {
            print(
              'Background removed successfully! Processed image size: ${processedImageBytes.length}',
            );
            print('Minimal post-processing applied to preserve image quality');
          }

          // Update state only if still mounted (prevents setState after dispose)
          if (!mounted) return;

          setState(() {
            _processedImage = processedImageBytes;
            _isProcessing = false;
          });

          // Auto navigate to editor or background changer after processing
          await Future.delayed(const Duration(milliseconds: 500));

          if (mounted) {
            if (widget.backgroundOption != null) {
              // Navigate directly to background changer with preset
              Color? presetColor;
              bool isBlur = false;

              if (widget.backgroundOption == 'White') {
                presetColor = Colors.white;
              } else if (widget.backgroundOption == 'Black') {
                presetColor = Colors.black;
              } else if (widget.backgroundOption == 'Blur') {
                isBlur = true;
              }

              context.router.replace(
                BackgroundChangerRoute(
                  processedImage: processedImageBytes,
                  initialColor: presetColor,
                  initialBlur: isBlur,
                ),
              );
            } else {
              // Navigate to editor (normal flow)
              context.router.replace(
                EditorRoute(
                  originalImage: widget.imageFile,
                  processedImage: processedImageBytes,
                ),
              );
            }
          }
        } else {
          throw Exception('Failed to convert processed image');
        }
      } catch (e) {
        // Handle errors during background removal
        if (kDebugMode) {
          print('Error during background removal: $e');
          print('Stack trace: ${StackTrace.current}');
        }

        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
        }

        if (mounted) {
          String errorMessage = 'Failed to remove background';

          // Provide more specific error messages
          if (e.toString().contains('memory') ||
              e.toString().contains('OutOfMemory')) {
            errorMessage = 'Image too large. Please try a smaller image.';
          } else if (e.toString().contains('decode') ||
              e.toString().contains('format')) {
            errorMessage = 'Unsupported image format. Please use JPG or PNG.';
          } else if (e.toString().contains('ONNX') ||
              e.toString().contains('model')) {
            errorMessage = 'Background removal failed. Please try again.';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
          Navigator.pop(context);
        }
        return;
      }
    } catch (e) {
      // Handle general errors
      if (kDebugMode) {
        print('Error processing image: $e');
        print('Stack trace: ${StackTrace.current}');
      }

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }

      if (mounted) {
        String errorMessage = 'Failed to process image';

        // Provide more specific error messages
        if (e.toString().contains('memory') ||
            e.toString().contains('OutOfMemory')) {
          errorMessage = 'Image too large. Please try a smaller image.';
        } else if (e.toString().contains('decode') ||
            e.toString().contains('format')) {
          errorMessage = 'Unable to read image. Please try a different photo.';
        } else if (e.toString().contains('permission')) {
          errorMessage = 'Permission denied. Please check app permissions.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Image preview area
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Image with animated scanning line
                    Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _imageBytes != null
                            ? Image.memory(
                                _imageBytes!,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback to Image.file if memory fails
                                  return Image.file(
                                    widget.imageFile,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey.shade300,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.error_outline,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Failed to load image',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              )
                            : Image.file(
                                widget.imageFile,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade300,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Failed to load image\n(HEIC format not supported)',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),

                    // Scanning line animation
                    if (_isProcessing)
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Positioned(
                            top:
                                MediaQuery.of(context).size.height * 0.2 +
                                (MediaQuery.of(context).size.height *
                                    0.4 *
                                    _animation.value),
                            left: 20,
                            right: 20,
                            child: Container(
                              height: 3,
                              decoration: BoxDecoration(
                                color: AppColors.primaryCoral,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryCoral.withValues(
                                      alpha: 0.5,
                                    ),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),

            // Bottom section with scanning button
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primaryCoral,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: _isProcessing
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  AppStrings.scanning,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : const Text(
                              'Processing Complete',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
