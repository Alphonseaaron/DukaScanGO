import 'package:dukascango/presentation/screens/central_admin/platform_settings/edit_template_screen.dart';
import 'package:flutter/material.dart';

class NotificationTemplatesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Templates'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Welcome Email'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTemplateScreen(templateName: 'Welcome Email'),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Password Reset Email'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTemplateScreen(templateName: 'Password Reset Email'),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Order Confirmation SMS'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTemplateScreen(templateName: 'Order Confirmation SMS'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
