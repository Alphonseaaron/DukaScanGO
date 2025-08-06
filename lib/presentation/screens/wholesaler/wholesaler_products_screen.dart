import 'package:flutter/material.dart';
import 'package:dukascango/presentation/components/components.dart';

class WholesalerProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextCustom(text: 'Products'),
      ),
      body: Center(
        child: TextCustom(text: 'Wholesaler Products'),
      ),
    );
  }
}
