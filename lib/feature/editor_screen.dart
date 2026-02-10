import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/feature/constants/app_colors.dart';
import 'package:flutter_project/feature/constants/app_strings.dart';
import 'package:flutter_project/feature/shared/navigation/app_router.gr.dart';

@RoutePage()
class EditorPage extends StatefulWidget {
  final File originalImage;
  final Uint8List processedImage;

  const EditorPage({
    super.key,
    required this.originalImage,
    required this.processedImage,
  });

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final List<Offset> _currentStroke = [];
  final List<List<Offset>> _allStrokes = [];
  final List<Uint8List> _imageHistory = [];
  double _brushSize = 20.0;
  final GlobalKey _imageKey = GlobalKey();
  ui.Image? _editableImage;
  Uint8List? _modifiedImageBytes;
  Offset? _currentTouchPosition;

  // Zoom and pan variables
  double _scale = 1.0;
  double _previousScale = 1.0;
  Offset _offset = Offset.zero;
  Offset _startFocalPoint = Offset.zero;
  int _pointerCount = 0;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final codec = await ui.instantiateImageCodec(widget.processedImage);
    final frame = await codec.getNextFrame();
    setState(() {
      _editableImage = frame.image;
      _modifiedImageBytes = widget.processedImage;
    });
  }

  void _undo() async {
    if (_imageHistory.isNotEmpty) {
      final previousImage = _imageHistory.removeLast();
      final codec = await ui.instantiateImageCodec(previousImage);
      final frame = await codec.getNextFrame();

      setState(() {
        _modifiedImageBytes = previousImage;
        _editableImage = frame.image;
        if (_allStrokes.isNotEmpty) {
          _allStrokes.removeLast();
        }
        _currentTouchPosition = null; // Clear marker on undo
      });
    }
  }

  void _reset() async {
    setState(() {
      _currentStroke.clear();
      _allStrokes.clear();
      _imageHistory.clear();
      _modifiedImageBytes = null;
      _scale = 1.0;
      _previousScale = 1.0;
      _offset = Offset.zero;
      _currentTouchPosition = null; // Clear marker on reset
    });
    await _loadImage();
  }

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _pointerCount++;
      // Clear marker if switching to multi-touch
      if (_pointerCount > 1) {
        _currentTouchPosition = null;
      }
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _pointerCount--;
      _currentTouchPosition = null; // Clear marker when finger is lifted
    });
  }

  void _onScaleStart(ScaleStartDetails details) {
    setState(() {
      _startFocalPoint = details.focalPoint;
      _previousScale = _scale;
    });

    // Show marker immediately on single finger touch
    if (details.pointerCount == 1 && _pointerCount == 1) {
      final RenderBox? box =
          _imageKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        final localPosition = box.globalToLocal(details.focalPoint);
        setState(() {
          _currentTouchPosition = localPosition;
        });
      }
    } else {
      // Clear marker for multi-touch gestures
      setState(() {
        _currentTouchPosition = null;
      });
    }
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount == 1 && _pointerCount == 1) {
      // Single finger - erase
      final RenderBox? box =
          _imageKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        final localPosition = box.globalToLocal(details.focalPoint);
        // Calculate erase position above finger (where upper marker will be)
        final erasePosition = Offset(
          localPosition.dx,
          localPosition.dy -
              _brushSize -
              50, // Increased distance between markers
        );
        setState(() {
          _currentStroke.add(erasePosition); // Erase happens at upper marker
          _currentTouchPosition = localPosition; // Finger position for display
        });
      }
    } else if (details.pointerCount >= 2) {
      // Two or more fingers: zoom and pan
      setState(() {
        // Update scale with dampening
        final scaleDelta = details.scale - 1.0;
        final dampedScaleDelta = scaleDelta * 0.3; // 30% of original speed
        _scale = (_previousScale * (1.0 + dampedScaleDelta)).clamp(0.5, 4.0);

        // Update offset for panning with dampening
        final Offset delta = details.focalPoint - _startFocalPoint;
        _offset += delta * 0.3;
        _startFocalPoint = details.focalPoint;

        _currentTouchPosition = null; // Clear marker when zooming/panning
      });
    }
  }

  void _onScaleEnd(ScaleEndDetails details) async {
    if (_currentStroke.isNotEmpty && _pointerCount <= 1) {
      // Save stroke and apply erasing
      setState(() {
        _allStrokes.add(List.from(_currentStroke));
      });
      await _applyErasing();
      setState(() {
        _currentStroke.clear();
        _currentTouchPosition = null; // Clear marker when stroke ends
      });
    } else {
      // Clear marker even if no stroke was made
      setState(() {
        _currentTouchPosition = null;
      });
    }
  }

  Future<void> _applyErasing() async {
    if (_editableImage == null || _currentStroke.isEmpty) return;

    // Save current state to history
    if (_modifiedImageBytes != null) {
      _imageHistory.add(Uint8List.fromList(_modifiedImageBytes!));
    } else {
      _imageHistory.add(Uint8List.fromList(widget.processedImage));
    }

    // Get image dimensions
    final imageWidth = _editableImage!.width;
    final imageHeight = _editableImage!.height;

    // Get the image widget's render box
    final RenderBox? imageBox =
        _imageKey.currentContext?.findRenderObject() as RenderBox?;
    if (imageBox == null) return;

    final imageDisplaySize = imageBox.size;

    // Calculate scale for BoxFit.contain
    final scaleX = imageDisplaySize.width / imageWidth;
    final scaleY = imageDisplaySize.height / imageHeight;
    final displayScale = scaleX < scaleY ? scaleX : scaleY;

    // Calculate centered position
    final displayedWidth = imageWidth * displayScale;
    final displayedHeight = imageHeight * displayScale;
    final offsetX = (imageDisplaySize.width - displayedWidth) / 2;
    final offsetY = (imageDisplaySize.height - displayedHeight) / 2;

    // Create a picture recorder
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw current image
    final paint = Paint();
    canvas.drawImage(_editableImage!, Offset.zero, paint);

    // Create erase paint with clear blend mode
    final erasePaint = Paint()
      ..color = Colors.transparent
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _brushSize / displayScale
      ..blendMode = BlendMode.clear
      ..style = PaintingStyle.stroke;

    // Transform and draw stroke on image
    for (int i = 0; i < _currentStroke.length - 1; i++) {
      final point1 = _currentStroke[i];
      final point2 = _currentStroke[i + 1];

      // Transform display coordinates to image coordinates
      final imagePoint1 = Offset(
        (point1.dx - offsetX) / displayScale,
        (point1.dy - offsetY) / displayScale,
      );
      final imagePoint2 = Offset(
        (point2.dx - offsetX) / displayScale,
        (point2.dy - offsetY) / displayScale,
      );

      // Draw line to erase
      canvas.drawLine(imagePoint1, imagePoint2, erasePaint);

      // Also draw circles at points for smoother erasing
      canvas.drawCircle(imagePoint1, _brushSize / displayScale / 2, erasePaint);
    }

    // Draw final point
    if (_currentStroke.isNotEmpty) {
      final lastPoint = _currentStroke.last;
      final imagePoint = Offset(
        (lastPoint.dx - offsetX) / displayScale,
        (lastPoint.dy - offsetY) / displayScale,
      );
      canvas.drawCircle(imagePoint, _brushSize / displayScale / 2, erasePaint);
    }

    // Convert to image
    final picture = recorder.endRecording();
    final modifiedImage = await picture.toImage(imageWidth, imageHeight);
    final byteData = await modifiedImage.toByteData(
      format: ui.ImageByteFormat.png,
    );

    if (byteData != null) {
      setState(() {
        _modifiedImageBytes = byteData.buffer.asUint8List();
        _editableImage = modifiedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildToolbar(),
            Expanded(child: _buildCanvas()),
            _buildBrushSlider(),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
            iconSize: 28,
          ),
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _imageHistory.isNotEmpty ? _undo : null,
            iconSize: 28,
            color: _imageHistory.isNotEmpty ? Colors.black : Colors.grey,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: null,
            iconSize: 28,
            color: Colors.grey,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reset,
            iconSize: 28,
          ),
          ElevatedButton(
            onPressed: () {
              context.router.push(
                BackgroundChangerRoute(
                  processedImage: _modifiedImageBytes ?? widget.processedImage,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCoral,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              AppStrings.done,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCanvas() {
    return Container(
      color: Colors.grey.shade100,
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerUp: _onPointerUp,
        child: Stack(
          children: [
            // Checkerboard background
            CustomPaint(painter: CheckerboardPainter(), size: Size.infinite),

            // Main canvas with zoom support
            Center(
              child: GestureDetector(
                onScaleStart: _onScaleStart,
                onScaleUpdate: _onScaleUpdate,
                onScaleEnd: _onScaleEnd,
                child: Transform.translate(
                  offset: _offset,
                  child: Transform.scale(
                    scale: _scale,
                    child: Stack(
                      children: [
                        Image.memory(
                          key: _imageKey,
                          _modifiedImageBytes ?? widget.processedImage,
                          fit: BoxFit.contain,
                        ),
                        // Draw current stroke overlay
                        CustomPaint(
                          painter: StrokePainter(
                            _currentStroke,
                            _brushSize,
                            _currentTouchPosition,
                          ),
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrushSlider() {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _brushSize = (_brushSize - 5).clamp(5, 50);
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryCoral,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
              ),
              Expanded(
                child: Slider(
                  value: _brushSize,
                  min: 5,
                  max: 50,
                  activeColor: AppColors.primaryCoral,
                  onChanged: (value) {
                    setState(() {
                      _brushSize = value;
                    });
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _brushSize = (_brushSize + 5).clamp(5, 50);
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryCoral,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.manualEraseHint,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class StrokePainter extends CustomPainter {
  final List<Offset> points;
  final double brushSize;
  final Offset? currentTouchPosition;

  StrokePainter(this.points, this.brushSize, this.currentTouchPosition);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty && currentTouchPosition == null) return;

    final paint = Paint()
      ..color = AppColors.primaryCoral.withValues(alpha: 0.5)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = brushSize
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    // Draw circles at each point for smoother appearance
    for (final point in points) {
      canvas.drawCircle(point, brushSize / 2, paint);
    }

    // Draw two red markers at current touch position
    if (currentTouchPosition != null) {
      // Calculate offset for the erase marker (above finger position)
      final eraseMarkerPosition = Offset(
        currentTouchPosition!.dx,
        currentTouchPosition!.dy -
            brushSize -
            50, // Increased distance between markers
      );

      // Marker 1: At finger position (outline circle)
      final fingerMarkerPaint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawCircle(
        currentTouchPosition!,
        brushSize / 2 + 3,
        fingerMarkerPaint,
      );

      // Marker 2: Above finger position (filled circle showing erase area)
      final eraseMarkerOutlinePaint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(
        eraseMarkerPosition,
        brushSize / 2 + 2,
        eraseMarkerOutlinePaint,
      );

      final eraseMarkerFillPaint = Paint()
        ..color = Colors.red.withValues(alpha: 0.4)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        eraseMarkerPosition,
        brushSize / 2,
        eraseMarkerFillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(StrokePainter oldDelegate) =>
      oldDelegate.points != points ||
      oldDelegate.brushSize != brushSize ||
      oldDelegate.currentTouchPosition != currentTouchPosition;
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
