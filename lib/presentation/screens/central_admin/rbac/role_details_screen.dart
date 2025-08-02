import 'package:flutter/material.dart';

class RoleDetailsScreen extends StatelessWidget {
  final Map<String, String> role;

  const RoleDetailsScreen({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Role Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${role['id']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Name: ${role['name']}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
