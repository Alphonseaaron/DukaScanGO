import 'package:flutter/material.dart';

class CurrenciesScreen extends StatefulWidget {
  @override
  _CurrenciesScreenState createState() => _CurrenciesScreenState();
}

class _CurrenciesScreenState extends State<CurrenciesScreen> {
  // TODO: Fetch real data
  final _currencies = {
    'USD': true,
    'EUR': true,
    'GBP': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currencies'),
      ),
      body: ListView.builder(
        itemCount: _currencies.length,
        itemBuilder: (context, index) {
          final currency = _currencies.keys.elementAt(index);
          final isEnabled = _currencies[currency]!;
          return SwitchListTile(
            title: Text(currency),
            value: isEnabled,
            onChanged: (value) {
              setState(() {
                _currencies[currency] = value;
              });
            },
          );
        },
      ),
    );
  }
}
