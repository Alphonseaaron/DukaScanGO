import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CustomCameraScanner extends StatefulWidget {
  final Function(String) onBarcodeDetected;

  const CustomCameraScanner({Key? key, required this.onBarcodeDetected}) : super(key: key);

  @override
  _CustomCameraScannerState createState() => _CustomCameraScannerState();
}

class _CustomCameraScannerState extends State<CustomCameraScanner> with SingleTickerProviderStateMixin {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  late AnimationController _animationController;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.high);
    await _cameraController.initialize();
    if (!mounted) return;
    setState(() {});
    _cameraController.startImageStream((image) {
      if (_isDetecting) return;
      _isDetecting = true;
      // Mock barcode detection
      Future.delayed(const Duration(seconds: 2), () {
        widget.onBarcodeDetected('mock_barcode');
        _isDetecting = false;
      });
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Stack(
      children: [
        CameraPreview(_cameraController),
        _buildScannerOverlay(),
        _buildScanningAnimation(),
      ],
    );
  }

  Widget _buildScannerOverlay() {
    return CustomPaint(
      size: Size.infinite,
      painter: _ScannerOverlayPainter(),
    );
  }

  Widget _buildScanningAnimation() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: _ScannerAnimationPainter(_animationController.value),
          ),
        );
      },
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withAlpha(128);
    final background = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final scanWindowWidth = size.width * 0.8;
    final scanWindowHeight = size.width * 0.8;
    final scanWindowRect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: scanWindowWidth,
      height: scanWindowHeight,
    );
    final scanWindow = Path()..addRRect(RRect.fromRectAndRadius(scanWindowRect, const Radius.circular(12)));
    final path = Path.combine(PathOperation.difference, background, scanWindow);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ScannerAnimationPainter extends CustomPainter {
  final double position;
  _ScannerAnimationPainter(this.position);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;
    final scanWindowWidth = size.width * 0.8;
    final scanWindowHeight = size.width * 0.8;
    final scanWindowRect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: scanWindowWidth,
      height: scanWindowHeight,
    );
    final top = scanWindowRect.top + (scanWindowHeight * position);
    canvas.drawLine(Offset(scanWindowRect.left, top), Offset(scanWindowRect.right, top), paint);
  }

  @override
  bool shouldRepaint(covariant _ScannerAnimationPainter oldDelegate) => position != oldDelegate.position;
}
