import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dukascango/domain/bloc/blocs.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/helpers/animation_route.dart';
import 'package:dukascango/presentation/screens/client/cart_client_screen.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';
import 'package:dukascango/presentation/components/custom_camera_scanner.dart';

class ProductScanScreen extends StatefulWidget {
  @override
  _ProductScanScreenState createState() => _ProductScanScreenState();
}

class _ProductScanScreenState extends State<ProductScanScreen> {
  final _barcodeController = TextEditingController();

  @override
  void dispose() {
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selfScanBloc = BlocProvider.of<SelfScanBloc>(context);

    return BlocListener<SelfScanBloc, SelfScanState>(
      listener: (context, state) {
        if (!state.isProductFound) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  TextCustom(text: 'Product not found', color: Colors.white),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state.currentProduct != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: TextCustom(
                  text: '${state.currentProduct!.name} added to cart',
                  color: Colors.white),
              backgroundColor: ColorsDukascango.primaryColor,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const TextCustom(text: 'Scan Products'),
        ),
        body: Stack(
          children: [
            CustomCameraScanner(
              onBarcodeDetected: (barcode) {
                selfScanBloc.add(OnProductScannedEvent(barcode));
              },
            ),
            _buildUIOverlay(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUIOverlay(BuildContext context) {
    return Column(
      children: [
        // Placeholder for store logo
        Image.asset('Assets/Logo/logo-black.png', height: 50),
        const Spacer(),
        _buildUpsellBanner(context),
        // Manual Entry Button
        BtnDukascango(
          text: 'Enter Manually',
          onPressed: () {
            _showManualEntryBottomSheet(context);
          },
        ),
        const SizedBox(height: 20),
        _buildFooter(context),
      ],
    );
  }

  Widget _buildUpsellBanner(BuildContext context) {
    return BlocBuilder<SelfScanBloc, SelfScanState>(
      builder: (context, state) {
        if (state.showUpsellBanner) {
          return Dismissible(
            key: const Key('upsell_banner'),
            onDismissed: (_) {
              BlocProvider.of<SelfScanBloc>(context)
                  .add(OnDismissUpsellBannerEvent());
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: const TextCustom(
                text: 'Try this from another brand!',
                fontSize: 16,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          BlocBuilder<SelfScanBloc, SelfScanState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextCustom(
                      text:
                          'Cart: ${state.cart.length} items | Ksh ${state.total.toStringAsFixed(2)}'),
                  BtnDukascango(
                    text: 'View Cart & Checkout',
                    onPressed: () {
                      Navigator.push(
                          context,
                          routeDukascango(
                              page: CartClientScreen(isSelfScan: true)));
                    },
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          const TextCustom(
              text: 'Powered by DukaScanGO', color: Colors.grey, fontSize: 12),
        ],
      ),
    );
  }

  void _showManualEntryBottomSheet(BuildContext context) {
    final selfScanBloc = BlocProvider.of<SelfScanBloc>(context);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextCustom(text: 'Enter Barcode Manually'),
              const SizedBox(height: 20),
              FormFieldDukascango(
                controller: _barcodeController,
                hintText: 'Enter barcode',
              ),
              const SizedBox(height: 20),
              BtnDukascango(
                text: 'Submit',
                onPressed: () {
                  if (_barcodeController.text.isNotEmpty) {
                    selfScanBloc
                        .add(OnProductScannedEvent(_barcodeController.text));
                    _barcodeController.clear();
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
