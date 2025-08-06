import 'package:flutter/material.dart';
import 'package:dukascango/presentation/components/components.dart';

class WholesalerDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextCustom(text: 'Dashboard'),
      ),
      body: Center(
        child: TextCustom(text: 'Wholesaler Dashboard'),
      ),
    );
  }
}
