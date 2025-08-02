import 'package:flutter/material.dart';

class EditPageScreen extends StatelessWidget {
  final String pageTitle;

  const EditPageScreen({Key? key, required this.pageTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit $pageTitle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: 'This is the content of the $pageTitle page.',
              maxLines: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement save page logic
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
