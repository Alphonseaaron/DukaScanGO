import 'package:dukascango/presentation/screens/central_admin/rewards_gamification/referral_reward_screen.dart';
import 'package:flutter/material.dart';

class ReferralProgramScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Referral Program'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Configure Reward'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReferralRewardScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
