import 'package:flutter/material.dart';
import 'package:dukascango/presentation/components/components.dart';

class WholesalerOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextCustom(text: 'Orders'),
      ),
      body: Center(
        child: TextCustom(text: 'Wholesaler Orders'),
      ),
    );
  }
}
