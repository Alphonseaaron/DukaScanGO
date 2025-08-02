import 'package:dukascango/presentation/screens/central_admin/financial_management/payment_gateway_settings_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/financial_management/payouts_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/financial_management/revenue_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/financial_management/transactions_screen.dart';
import 'package:flutter/material.dart';

class FinancialManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Financial Management'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('All Transactions'),
            leading: Icon(Icons.receipt_long),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionsScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Payouts'),
            leading: Icon(Icons.payment),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PayoutsScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Revenue'),
            leading: Icon(Icons.bar_chart),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RevenueScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Payment Gateway Settings'),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentGatewaySettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
