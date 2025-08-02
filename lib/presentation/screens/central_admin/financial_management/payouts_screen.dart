import 'package:dukascango/domain/models/payout.dart';
import 'package:dukascango/domain/services/payout_service.dart';
import 'package:dukascango/presentation/screens/central_admin/financial_management/create_payout_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PayoutsScreen extends StatefulWidget {
  @override
  _PayoutsScreenState createState() => _PayoutsScreenState();
}

class _PayoutsScreenState extends State<PayoutsScreen> {
  late Future<List<Payout>> _payouts;

  @override
  void initState() {
    super.initState();
    _payouts = PayoutService().getPayouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payouts'),
      ),
      body: FutureBuilder<List<Payout>>(
        future: _payouts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No payouts found.'));
          } else {
            final payouts = snapshot.data!;
            return ListView.builder(
              itemCount: payouts.length,
              itemBuilder: (context, index) {
                final payout = payouts[index];
                return ListTile(
                  title: Text('Payout to ${payout.userType} (${payout.userId})'),
                  subtitle: Text(
                      'Amount: \$${payout.amount.toStringAsFixed(2)} - ${DateFormat.yMd().format(payout.date)}'),
                  trailing: Text(payout.status),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePayoutScreen(),
            ),
          ).then((_) {
            // Refresh the list when coming back
            setState(() {
              _payouts = PayoutService().getPayouts();
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
