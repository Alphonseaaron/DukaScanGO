import 'package:dukascango/domain/models/loyalty_point_rule.dart';
import 'package:dukascango/domain/services/loyalty_point_rule_service.dart';
import 'package:dukascango/presentation/helpers/modal_loading.dart';
import 'package:dukascango/presentation/helpers/modal_success.dart';
import 'package:flutter/material.dart';

class LoyaltyPointRulesScreen extends StatefulWidget {
  @override
  _LoyaltyPointRulesScreenState createState() =>
      _LoyaltyPointRulesScreenState();
}

class _LoyaltyPointRulesScreenState extends State<LoyaltyPointRulesScreen> {
  late Future<List<LoyaltyPointRule>> _rules;

  @override
  void initState() {
    super.initState();
    _rules = LoyaltyPointRuleService().getLoyaltyPointRules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loyalty Point Rules'),
      ),
      body: FutureBuilder<List<LoyaltyPointRule>>(
        future: _rules,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No rules found.'));
          } else {
            final rules = snapshot.data!;
            return ListView.builder(
              itemCount: rules.length,
              itemBuilder: (context, index) {
                final rule = rules[index];
                return ListTile(
                  title: Text(rule.action),
                  subtitle: Text('Points: ${rule.points}'),
                  onTap: () {
                    // TODO: Navigate to edit rule screen
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create rule screen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
