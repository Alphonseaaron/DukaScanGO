import 'package:dukascango/presentation/screens/central_admin/crm_support/create_ticket_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/crm_support/ticket_details_screen.dart';
import 'package:flutter/material.dart';

class TicketingSystemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Fetch real data
    final tickets = [
      {'id': '1', 'subject': 'Issue with order #123', 'status': 'Open'},
      {'id': '2', 'subject': 'Payment failed', 'status': 'Closed'},
      {'id': '3', 'subject': 'App crashing on startup', 'status': 'Open'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Ticketing System'),
      ),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return ListTile(
            title: Text(ticket['subject']!),
            subtitle: Text('ID: ${ticket['id']}'),
            trailing: Text(ticket['status']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketDetailsScreen(ticket: ticket),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTicketScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
