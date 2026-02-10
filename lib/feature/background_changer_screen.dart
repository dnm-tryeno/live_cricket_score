import 'dart:typed_data';
import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/feature/constants/app_colors.dart';
import 'package:flutter_project/feature/constants/app_strings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_project/feature/shared/navigation/app_router.gr.dart';

@RoutePage()
class BackgroundChangerPage extends StatefulWidget {
  final Uint8List processedImage;
  final Color? initialColor;
  final bool initialBlur;

  const BackgroundChangerPage({
    super.key,
    required this.processedImage,
    this.initialColor,
    this.initialBlur = false,
  });

  @override
  State<BackgroundChangerPage> createState() => _BackgroundChangerPageState();
}

class _BackgroundChangerPageState extends State<BackgroundChangerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Color? _selectedColor;
  List<Color>? _selectedGradient;
  String? _selectedBackground;
  Uint8List? _customBackgroundImage;
  bool _isBlurred = false;

  // Zoom variables for foreground image
  double _scale = 1.0;
  double _previousScale = 1.0;
  Offset _offset = Offset.zero;
  Offset _startFocalPoint = Offset.zero;
  int _pointerCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Set initial values if provided
    if (widget.initialColor != null) {
      _selectedColor = widget.initialColor;
    }
    if (widget.initialBlur) {
      _isBlurred = true;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Gesture handlers for zoom functionality
  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _pointerCount++;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _pointerCount = (_pointerCount - 1).clamp(0, 10);
    });
  }

  void _onScaleStart(ScaleStartDetails details) {
    setState(() {
      _startFocalPoint = details.focalPoint;
      _previousScale = _scale;
    });
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (_pointerCount >= 2) {
      // Two or more fingers: zoom and pan
      setState(() {
        // Update scale with clamping
        _scale = (_previousScale * details.scale).clamp(0.5, 4.0);

        // Update offset for panning with dampening
        final Offset delta = details.focalPoint - _startFocalPoint;
        _offset += delta * 0.3;
        _startFocalPoint = details.focalPoint;
      });
    }
  }

  void _onScaleEnd(ScaleEndDetails details) {
    setState(() {
      _previousScale = _scale;
    });
  }

  Future<void> _pickCustomBackground() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();
        setState(() {
          _customBackgroundImage = imageBytes;
          _selectedBackground = null;
          _selectedColor = null;
          _selectedGradient = null;
          _isBlurred = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error picking image: $e');
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
          AppStrings.changeBackground,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: () {
                context.router.push(
                  SaveRoute(
                    processedImage: widget.processedImage,
                    backgroundColor: _selectedColor,
                    gradientColors: _selectedGradient,
                    backgroundImage: _selectedBackground,
                    customBackgroundImage: _customBackgroundImage,
                    isBlurred: _isBlurred,
                    scale: _scale,
                    offset: _offset,
                  ),
                );
              },
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
              child: const Text(
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
          _buildBottomTabs(),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _selectedColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Listener(
          onPointerDown: _onPointerDown,
          onPointerUp: _onPointerUp,
          child: GestureDetector(
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            onScaleEnd: _onScaleEnd,
            child: Stack(
              children: [
                // Gradient background if selected
                if (_selectedGradient != null)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _selectedGradient!,
                        ),
                      ),
                    ),
                  ),

                // Custom background image if uploaded
                if (_customBackgroundImage != null)
                  Positioned.fill(
                    child: _isBlurred
                        ? ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: 10,
                              sigmaY: 10,
                            ),
                            child: Image.memory(
                              _customBackgroundImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.memory(
                            _customBackgroundImage!,
                            fit: BoxFit.cover,
                          ),
                  ),

                // Background image if selected
                if (_selectedBackground != null &&
                    _selectedBackground != 'None' &&
                    _customBackgroundImage == null)
                  Positioned.fill(
                    child: _isBlurred
                        ? ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: 10,
                              sigmaY: 10,
                            ),
                            child: Image.asset(
                              _selectedBackground!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(color: Colors.grey.shade300);
                              },
                            ),
                          )
                        : Image.asset(
                            _selectedBackground!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(color: Colors.grey.shade300);
                            },
                          ),
                  ),

                // Solid color background if selected (without gradient)
                if (_selectedColor != null && _selectedGradient == null)
                  Positioned.fill(
                    child: _isBlurred
                        ? ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: 10,
                              sigmaY: 10,
                            ),
                            child: Container(color: _selectedColor),
                          )
                        : Container(color: _selectedColor),
                  ),

                // Checkerboard for transparent background
                if (_selectedColor == null &&
                    _selectedGradient == null &&
                    _selectedBackground == null &&
                    _customBackgroundImage == null &&
                    !_isBlurred)
                  CustomPaint(
                    painter: CheckerboardPainter(),
                    size: Size.infinite,
                  ),

                // Blurred checkerboard
                if (_isBlurred &&
                    _selectedColor == null &&
                    _selectedGradient == null &&
                    _selectedBackground == null &&
                    _customBackgroundImage == null)
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: CustomPaint(
                      painter: CheckerboardPainter(),
                      size: Size.infinite,
                    ),
                  ),

                // Processed image with zoom/pan transforms (ONLY foreground is transformed)
                Center(
                  child: Transform.translate(
                    offset: _offset,
                    child: Transform.scale(
                      scale: _scale,
                      child: Image.memory(
                        widget.processedImage,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        isAntiAlias: true,
                        // Ensure transparency is properly handled
                        color: null,
                        colorBlendMode: null,
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

  Widget _buildBottomTabs() {
    return Container(
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
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primaryCoral,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primaryCoral,
            tabs: const [
              Tab(icon: Icon(Icons.image), text: AppStrings.bgChanger),
              Tab(icon: Icon(Icons.palette), text: AppStrings.solidBG),
              Tab(icon: Icon(Icons.gradient), text: AppStrings.gradientBG),
            ],
          ),
          SizedBox(
            height: 120,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBackgroundOptions(),
                _buildSolidColorOptions(),
                _buildGradientOptions(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundOptions() {
    final backgrounds = [
      {'name': 'None', 'image': null},
      {
        'name': 'Floral',
        'image': 'assets/backgrounds/bgImages/floral_wall.jpeg',
      },
      {
        'name': 'Golden',
        'image': 'assets/backgrounds/bgImages/golden_sparkle.jpeg',
      },
      {'name': 'BG 6', 'image': 'assets/backgrounds/bgImages/6.png'},
      {'name': 'BG 7', 'image': 'assets/backgrounds/bgImages/7.png'},
      {'name': 'BG 8', 'image': 'assets/backgrounds/bgImages/8.png'},
      {'name': 'BG 9', 'image': 'assets/backgrounds/bgImages/9.png'},
      {'name': 'BG 11', 'image': 'assets/backgrounds/bgImages/11.png'},
      {'name': 'BG 12', 'image': 'assets/backgrounds/bgImages/12.png'},
      {'name': 'BG 13', 'image': 'assets/backgrounds/bgImages/13.png'},
      {'name': 'BG 14', 'image': 'assets/backgrounds/bgImages/14.png'},
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: backgrounds.length + 1, // +1 for upload option
      itemBuilder: (context, index) {
        // Upload option at the beginning
        if (index == 0) {
          final isSelected = _customBackgroundImage != null;
          return GestureDetector(
            onTap: _pickCustomBackground,
            child: Container(
              width: 90,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryCoral
                            : Colors.grey.shade300,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: _customBackgroundImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              _customBackgroundImage!,
                              fit: BoxFit.cover,
                              width: 90,
                              height: 70,
                            ),
                          )
                        : Icon(
                            Icons.add_photo_alternate,
                            color: Colors.grey.shade600,
                            size: 35,
                          ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Upload',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final bg = backgrounds[index - 1];
        final isSelected =
            _selectedBackground == bg['image'] &&
            _customBackgroundImage == null;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedBackground = bg['image'];
              _selectedColor = null;
              _selectedGradient = null;
              _customBackgroundImage = null;
              _isBlurred = false;
            });
          },
          child: Container(
            width: 90,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Container(
                  width: 90,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryCoral
                          : Colors.grey.shade300,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: bg['name'] == 'None'
                      ? Icon(Icons.block, color: Colors.grey.shade600)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: bg['image'] != null
                              ? Image.asset(
                                  bg['image'] as String,
                                  fit: BoxFit.cover,
                                  width: 90,
                                  height: 70,
                                  gaplessPlayback: true,
                                  errorBuilder: (context, error, stackTrace) {
                                    if (kDebugMode) {
                                      print(
                                        '❌ Error loading image: ${bg['image']}',
                                      );
                                      print('Error details: $error');
                                    }
                                    return Container(
                                      color: Colors.grey.shade300,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey.shade400,
                                            size: 30,
                                          ),
                                          if (kDebugMode)
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                4.0,
                                              ),
                                              child: Text(
                                                'Error',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 8,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  color: Colors.grey.shade300,
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey.shade400,
                                    size: 30,
                                  ),
                                ),
                        ),
                ),
                const SizedBox(height: 4),
                Text(
                  bg['name'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSolidColorOptions() {
    final colors = [
      Colors.white,
      Colors.black,
      Colors.red.shade400,
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.yellow.shade400,
      Colors.purple.shade400,
      Colors.orange.shade400,
      Colors.pink.shade400,
      Colors.teal.shade400,
      Colors.indigo.shade400,
      Colors.cyan.shade400,
      Colors.lime.shade400,
      Colors.amber.shade400,
      Colors.deepOrange.shade400,
      Colors.lightBlue.shade400,
      Colors.lightGreen.shade400,
      Colors.deepPurple.shade400,
      const Color(0xFFFF1744), // Vibrant Red
      const Color(0xFFE91E63), // Vibrant Pink
      const Color(0xFF9C27B0), // Vibrant Purple
      const Color(0xFF673AB7), // Deep Purple
      const Color(0xFF3F51B5), // Indigo Blue
      const Color(0xFF2196F3), // Bright Blue
      const Color(0xFF03A9F4), // Light Blue
      const Color(0xFF00BCD4), // Cyan
      const Color(0xFF009688), // Teal
      const Color(0xFF4CAF50), // Green
      const Color(0xFF8BC34A), // Light Green
      const Color(0xFFCDDC39), // Lime
      const Color(0xFFFFEB3B), // Yellow
      const Color(0xFFFFC107), // Amber
      const Color(0xFFFF9800), // Orange
      const Color(0xFFFF5722), // Deep Orange
      const Color(0xFF795548), // Brown
      const Color(0xFF9E9E9E), // Grey
      Colors.grey.shade300,
      Colors.grey.shade700,
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount:
          colors.length + 2, // +1 for custom color picker, +1 for blur option
      itemBuilder: (context, index) {
        // Custom color picker option (first item)
        if (index == 0) {
          return GestureDetector(
            onTap: () => _showCustomColorPicker(),
            child: Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                gradient: SweepGradient(
                  colors: [
                    Colors.red,
                    Colors.yellow,
                    Colors.green,
                    Colors.cyan,
                    Colors.blue,
                    Colors.pink.shade400,
                    Colors.red,
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.colorize,
                  color: Colors.grey.shade700,
                  size: 24,
                ),
              ),
            ),
          );
        }

        // Blur option (last item)
        if (index == colors.length + 1) {
          final isSelected =
              _isBlurred &&
              _selectedColor == null &&
              _selectedGradient == null &&
              _selectedBackground == null;
          return GestureDetector(
            onTap: () {
              setState(() {
                _isBlurred = !_isBlurred;
                if (_isBlurred) {
                  _selectedColor = null;
                  _selectedGradient = null;
                  _selectedBackground = null;
                }
              });
            },
            child: Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryCoral
                      : Colors.grey.shade300,
                  width: isSelected ? 3 : 1,
                ),
              ),
              child: Icon(
                Icons.blur_on,
                color: isSelected
                    ? AppColors.primaryCoral
                    : Colors.grey.shade600,
                size: 30,
              ),
            ),
          );
        }

        // Regular color options (shifted by 1 because of custom picker at index 0)
        final color = colors[index - 1];
        final isSelected = _selectedColor == color && !_isBlurred;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedColor = color;
              _selectedGradient = null;
              _selectedBackground = null;
              _isBlurred = false;
            });
          },
          child: Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryCoral
                    : Colors.grey.shade300,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 30)
                : null,
          ),
        );
      },
    );
  }

  Widget _buildGradientOptions() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: AppColors.gradientBackgrounds.length,
      itemBuilder: (context, index) {
        final gradient = AppColors.gradientBackgrounds[index];
        final isSelected = _selectedGradient == gradient;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedGradient = gradient;
              _selectedColor = null;
              _selectedBackground = null;
              _isBlurred = false;
            });
          },
          child: Container(
            width: 90,
            height: 90,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryCoral
                    : Colors.grey.shade300,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 30)
                : null,
          ),
        );
      },
    );
  }

  void _showCustomColorPicker() {
    Color pickerColor = _selectedColor ?? Colors.blue;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              backgroundColor: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Choose Color',
                          style: TextStyle(
                            fontFamily: 'CaveatBrush',
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3436),
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: pickerColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: pickerColor.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Color Picker
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ColorPicker(
                          pickerColor: pickerColor,
                          onColorChanged: (Color color) {
                            setDialogState(() {
                              pickerColor = color;
                            });
                          },
                          pickerAreaHeightPercent: 0.7,
                          enableAlpha: true,
                          displayThumbColor: true,
                          paletteType: PaletteType.hsvWithHue,
                          labelTypes: const [],
                          pickerAreaBorderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Hex Color Code Display
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.palette,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '#${((pickerColor.r * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}${((pickerColor.g * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}${((pickerColor.b * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}'
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                              letterSpacing: 1.2,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(
                                color: Colors.grey.shade400,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'CaveatBrush',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedColor = pickerColor;
                                _selectedGradient = null;
                                _selectedBackground = null;
                                _isBlurred = false;
                              });
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryCoral,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 2,
                              shadowColor: AppColors.primaryCoral.withValues(
                                alpha: 0.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Confirm',
                              style: TextStyle(
                                fontFamily: 'CaveatBrush',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
