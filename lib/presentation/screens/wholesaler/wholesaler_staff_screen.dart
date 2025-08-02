import 'package:flutter/material.dart';
import 'package:dukascango/presentation/components/components.dart';

class WholesalerStaffScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextCustom(text: 'Staff'),
      ),
      body: Center(
        child: TextCustom(text: 'Wholesaler Staff'),
      ),
    );
  }
}
