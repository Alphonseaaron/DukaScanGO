import 'package:dukascango/domain/models/referral_reward.dart';
import 'package:dukascango/domain/services/referral_reward_service.dart';
import 'package:dukascango/presentation/helpers/modal_loading.dart';
import 'package:dukascango/presentation/helpers/modal_success.dart';
import 'package:flutter/material.dart';

class ReferralRewardScreen extends StatefulWidget {
  @override
  _ReferralRewardScreenState createState() => _ReferralRewardScreenState();
}

class _ReferralRewardScreenState extends State<ReferralRewardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  late Future<ReferralReward?> _reward;

  @override
  void initState() {
    super.initState();
    _reward = ReferralRewardService().getReferralReward();
    _reward.then((reward) {
      if (reward != null) {
        _amountController.text = reward.amount.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Referral Reward'),
      ),
      body: FutureBuilder<ReferralReward?>(
        future: _reward,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(labelText: 'Reward Amount'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          modalLoading(context);
                          final reward = ReferralReward(
                            amount: double.parse(_amountController.text),
                          );
                          await ReferralRewardService()
                              .updateReferralReward(reward);
                          Navigator.pop(context);
                          modalSuccess(context, 'Reward updated successfully!',
                              onPressed: () => Navigator.pop(context));
                        }
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
