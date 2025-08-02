import 'package:dukascango/presentation/screens/central_admin/platform_settings/currencies_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/platform_settings/languages_screen.dart';
import 'package:flutter/material.dart';

class GlobalSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Global Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Currencies'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CurrenciesScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Languages'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LanguagesScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
