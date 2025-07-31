import 'package:flutter/material.dart';
import 'package:dukascango/presentation/components/unified_scanner.dart';
import 'package:dukascango/presentation/components/text_custom.dart';

class AdminScanReceiptScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextCustom(text: 'Scan Receipt'),
      ),
      body: UnifiedScanner(
        scanAreaShape: ScanAreaShape.Square,
        onScan: (receiptId) {
          Navigator.pop(context, receiptId);
        },
      ),
    );
  }
}
