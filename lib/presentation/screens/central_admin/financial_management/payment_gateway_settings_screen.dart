import 'package:dukascango/presentation/screens/central_admin/financial_management/paypal_settings_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/financial_management/stripe_settings_screen.dart';
import 'package:flutter/material.dart';

class PaymentGatewaySettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Gateway Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Stripe'),
            subtitle: Text('Connected'),
            trailing: Icon(Icons.check_circle, color: Colors.green),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StripeSettingsScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('PayPal'),
            subtitle: Text('Not connected'),
            trailing: Icon(Icons.cancel, color: Colors.red),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PayPalSettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
