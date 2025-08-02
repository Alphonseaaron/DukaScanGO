import 'package:dukascango/presentation/screens/central_admin/financial_management/agent_payouts_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/financial_management/store_payouts_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/financial_management/wholesaler_payouts_screen.dart';
import 'package:flutter/material.dart';

class PayoutsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payouts'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Store Payouts'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StorePayoutsScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Wholesaler Payouts'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WholesalerPayoutsScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Agent Payouts'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AgentPayoutsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
