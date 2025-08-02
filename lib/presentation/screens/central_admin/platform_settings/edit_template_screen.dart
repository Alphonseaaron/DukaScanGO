import 'package:flutter/material.dart';

class EditTemplateScreen extends StatelessWidget {
  final String templateName;

  const EditTemplateScreen({Key? key, required this.templateName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit $templateName'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: 'This is the content of the $templateName template.',
              maxLines: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement save template logic
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
