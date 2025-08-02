import 'package:dukascango/presentation/screens/central_admin/rewards_gamification/loyalty_system_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/rewards_gamification/performance_bonuses_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/rewards_gamification/referral_program_screen.dart';
import 'package:flutter/material.dart';

class RewardsGamificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rewards & Gamification'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Performance Bonuses'),
            leading: Icon(Icons.star),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PerformanceBonusesScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Referral Program'),
            leading: Icon(Icons.group_add),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReferralProgramScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Loyalty & Engagement'),
            leading: Icon(Icons.favorite),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoyaltySystemScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
