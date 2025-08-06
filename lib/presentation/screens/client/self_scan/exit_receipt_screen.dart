import 'package:flutter/material.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';
import 'package:dukascango/presentation/components/custom_qr_code.dart';

class ExitReceiptScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextCustom(text: 'Exit Receipt'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('Assets/Logo/logo-black.png', height: 100),
            const SizedBox(height: 20),
            const TextCustom(text: 'Scan this QR code at the exit', fontSize: 18),
            const SizedBox(height: 20),
            const CustomQrCode(
              data: 'dummy_transaction_id', // Replace with actual transaction data
              size: 200.0,
            ),
            const Spacer(),
            const TextCustom(text: 'Powered by DSG', color: Colors.grey),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
