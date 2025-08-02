import 'package:dukascango/presentation/screens/central_admin/platform_settings/cms_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/platform_settings/global_settings_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/platform_settings/notification_templates_screen.dart';
import 'package:flutter/material.dart';

class PlatformSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Platform Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Global Settings'),
            leading: Icon(Icons.language),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GlobalSettingsScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('CMS'),
            leading: Icon(Icons.web),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CmsScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Notification Templates'),
            leading: Icon(Icons.notifications),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationTemplatesScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
