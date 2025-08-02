import 'package:dukascango/presentation/screens/central_admin/crm_support/communication_tools_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/crm_support/internal_knowledge_base_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/crm_support/ticketing_system_screen.dart';
import 'package:flutter/material.dart';

class CrmSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRM & Support'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Ticketing System'),
            leading: Icon(Icons.support),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketingSystemScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Internal Knowledge Base'),
            leading: Icon(Icons.library_books),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InternalKnowledgeBaseScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Communication Tools'),
            leading: Icon(Icons.message),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommunicationToolsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
