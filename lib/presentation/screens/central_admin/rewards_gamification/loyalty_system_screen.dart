import 'package:dukascango/presentation/screens/central_admin/rewards_gamification/loyalty_point_rules_screen.dart';
import 'package:flutter/material.dart';

class LoyaltySystemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loyalty System'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Configure Rules'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoyaltyPointRulesScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
