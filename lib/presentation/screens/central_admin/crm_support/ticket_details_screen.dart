import 'package:flutter/material.dart';

class TicketDetailsScreen extends StatelessWidget {
  final Map<String, String> ticket;

  const TicketDetailsScreen({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${ticket['id']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Subject: ${ticket['subject']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Status: ${ticket['status']}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
