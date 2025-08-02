import 'package:dukascango/domain/models/payment_gateway_settings.dart';
import 'package:dukascango/domain/services/payment_gateway_settings_service.dart';
import 'package:dukascango/presentation/screens/central_admin/financial_management/paypal_settings_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/financial_management/stripe_settings_screen.dart';
import 'package:flutter/material.dart';

class PaymentGatewaySettingsScreen extends StatefulWidget {
  @override
  _PaymentGatewaySettingsScreenState createState() =>
      _PaymentGatewaySettingsScreenState();
}

class _PaymentGatewaySettingsScreenState
    extends State<PaymentGatewaySettingsScreen> {
  late Future<List<PaymentGatewaySettings>> _settings;

  @override
  void initState() {
    super.initState();
    _settings = PaymentGatewaySettingsService().getPaymentGatewaySettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Gateway Settings'),
      ),
      body: FutureBuilder<List<PaymentGatewaySettings>>(
        future: _settings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No payment gateway settings found.'));
          } else {
            final settings = snapshot.data!;
            return ListView.builder(
              itemCount: settings.length,
              itemBuilder: (context, index) {
                final setting = settings[index];
                return SwitchListTile(
                  title: Text(setting.gatewayName),
                  subtitle: Text(setting.isEnabled ? 'Connected' : 'Not connected'),
                  value: setting.isEnabled,
                  onChanged: (value) {
                    // TODO: Implement update logic
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
