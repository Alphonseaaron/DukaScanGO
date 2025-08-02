import 'package:dukascango/domain/models/payout.dart';
import 'package:dukascango/domain/services/payout_service.dart';
import 'package:dukascango/presentation/helpers/modal_loading.dart';
import 'package:dukascango/presentation/helpers/modal_success.dart';
import 'package:flutter/material.dart';

class CreatePayoutScreen extends StatefulWidget {
  @override
  _CreatePayoutScreenState createState() => _CreatePayoutScreenState();
}

class _CreatePayoutScreenState extends State<CreatePayoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedUserType = 'store';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Payout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _userIdController,
                decoration: InputDecoration(labelText: 'User ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a user ID';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedUserType,
                items: [
                  DropdownMenuItem(value: 'store', child: Text('Store')),
                  DropdownMenuItem(
                      value: 'wholesaler', child: Text('Wholesaler')),
                  DropdownMenuItem(value: 'agent', child: Text('Agent')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedUserType = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'User Type'),
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
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
                    final payout = Payout(
                      userId: _userIdController.text,
                      userType: _selectedUserType,
                      amount: double.parse(_amountController.text),
                      status: 'pending',
                      date: DateTime.now(),
                    );
                    await PayoutService().addPayout(payout);
                    Navigator.pop(context);
                    modalSuccess(context, 'Payout created successfully!',
                        onPressed: () => Navigator.pop(context));
                  }
                },
                child: Text('Create Payout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
