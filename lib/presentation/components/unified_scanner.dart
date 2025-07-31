import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:ui';

enum ScanAreaShape { Square, Rectangle }

class UnifiedScanner extends StatefulWidget {
  final ScanAreaShape scanAreaShape;
  final Function(String) onScan;

  const UnifiedScanner({
    Key? key,
    required this.scanAreaShape,
    required this.onScan,
  }) : super(key: key);

  @override
  _UnifiedScannerState createState() => _UnifiedScannerState();
}

class _UnifiedScannerState extends State<UnifiedScanner> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Timer? _scanTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Simulate a scan after a delay
    _scanTimer = Timer(const Duration(seconds: 3), () {
      widget.onScan('mock_scan_result');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Scan successful!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scanTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Mock camera feed
        Container(
          color: Colors.black,
          child: Center(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Image.asset('Assets/Logo/logo-white.png', fit: BoxFit.cover, height: double.infinity, width: double.infinity),
            ),
          ),
        ),
        _buildScannerOverlay(),
        _buildScanningAnimation(),
      ],
    );
  }

  Widget _buildScannerOverlay() {
    return CustomPaint(
      size: Size.infinite,
      painter: _ScannerOverlayPainter(scanAreaShape: widget.scanAreaShape),
    );
  }

  Widget _buildScanningAnimation() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: _ScannerAnimationPainter(
              position: _animationController.value,
              scanAreaShape: widget.scanAreaShape,
            ),
          ),
        );
      },
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final ScanAreaShape scanAreaShape;
  _ScannerOverlayPainter({required this.scanAreaShape});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.5);
    final background = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final scanWindowWidth = size.width * 0.8;
    final scanWindowHeight = scanAreaShape == ScanAreaShape.Square ? scanWindowWidth : scanWindowWidth / 2;
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
  bool shouldRepaint(covariant _ScannerOverlayPainter oldDelegate) => false;
}

class _ScannerAnimationPainter extends CustomPainter {
  final double position;
  final ScanAreaShape scanAreaShape;
  _ScannerAnimationPainter({required this.position, required this.scanAreaShape});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;
    final scanWindowWidth = size.width * 0.8;
    final scanWindowHeight = scanAreaShape == ScanAreaShape.Square ? scanWindowWidth : scanWindowWidth / 2;
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
