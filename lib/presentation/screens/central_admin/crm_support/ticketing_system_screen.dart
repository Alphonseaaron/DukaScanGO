import 'package:dukascango/domain/models/ticket.dart';
import 'package:dukascango/domain/services/ticket_service.dart';
import 'package:dukascango/presentation/screens/central_admin/crm_support/create_ticket_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/crm_support/ticket_details_screen.dart';
import 'package:flutter/material.dart';

class TicketingSystemScreen extends StatefulWidget {
  @override
  _TicketingSystemScreenState createState() => _TicketingSystemScreenState();
}

class _TicketingSystemScreenState extends State<TicketingSystemScreen> {
  late Future<List<Ticket>> _tickets;

  @override
  void initState() {
    super.initState();
    _tickets = TicketService().getTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticketing System'),
      ),
      body: FutureBuilder<List<Ticket>>(
        future: _tickets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tickets found.'));
          } else {
            final tickets = snapshot.data!;
            return ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return ListTile(
                  title: Text(ticket.subject),
                  subtitle: Text('ID: ${ticket.id}'),
                  trailing: Text(ticket.status),
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
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTicketScreen(),
            ),
          ).then((_) {
            // Refresh the list when coming back
            setState(() {
              _tickets = TicketService().getTickets();
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
