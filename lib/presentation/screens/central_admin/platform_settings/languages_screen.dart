import 'package:flutter/material.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  // TODO: Fetch real data
  final _languages = {
    'English': true,
    'Spanish': true,
    'French': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Languages'),
      ),
      body: ListView.builder(
        itemCount: _languages.length,
        itemBuilder: (context, index) {
          final language = _languages.keys.elementAt(index);
          final isEnabled = _languages[language]!;
          return SwitchListTile(
            title: Text(language),
            value: isEnabled,
            onChanged: (value) {
              setState(() {
                _languages[language] = value;
              });
            },
          );
        },
      ),
    );
  }
}
