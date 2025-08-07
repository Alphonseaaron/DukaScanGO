import 'package:flutter/material.dart';
import 'package:dukascango/presentation/components/custom_camera_scanner.dart';
import 'package:dukascango/presentation/components/text_custom.dart';

class AdminScanBarcodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextCustom(text: 'Scan Barcode'),
      ),
      body: CustomCameraScanner(
        onBarcodeDetected: (barcode) {
          Navigator.pop(context, barcode);
        },
      ),
    );
  }
}
