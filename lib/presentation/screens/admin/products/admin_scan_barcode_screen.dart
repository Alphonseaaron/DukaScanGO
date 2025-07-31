import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:dukascango/presentation/components/text_custom.dart';

class AdminScanBarcodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextCustom(text: 'Scan Barcode'),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? barcode = barcodes.first.rawValue;
            if (barcode != null) {
              Navigator.pop(context, barcode);
            }
          }
        },
      ),
    );
  }
}
