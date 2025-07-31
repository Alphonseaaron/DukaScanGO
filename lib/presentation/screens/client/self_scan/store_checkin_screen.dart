import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dukascango/domain/bloc/blocs.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/screens/client/self_scan/product_scan_screen.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';
import 'package:dukascango/presentation/components/custom_camera_scanner.dart';

class StoreCheckinScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selfScanBloc = BlocProvider.of<SelfScanBloc>(context);

    return BlocListener<SelfScanBloc, SelfScanState>(
      listener: (context, state) {
        if (state.isSessionActive) {
          Navigator.pushReplacement(context, routeDukascango(page: ProductScanScreen()));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const TextCustom(text: 'Store Check-in'),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Stack(
          children: [
            CustomCameraScanner(
              onBarcodeDetected: (storeId) {
                selfScanBloc.add(OnStoreScannedEvent(storeId));
              },
            ),
            _buildInfoOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoOverlay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('Assets/Logo/logo-white.png', height: 100),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: TextCustom(
              text: 'To start scanning, please scan the store’s QR code near the entrance',
              color: Colors.white,
              fontSize: 18,
              textAlign: TextAlign.center,
              maxLine: 3,
            ),
          ),
          const Spacer(),
          const TextCustom(
            text: 'Powered by DukaScanGO',
            color: Colors.white,
            fontSize: 14,
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
