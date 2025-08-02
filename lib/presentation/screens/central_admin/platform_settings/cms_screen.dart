import 'package:dukascango/presentation/screens/central_admin/platform_settings/edit_page_screen.dart';
import 'package:flutter/material.dart';

class CmsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CMS'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('About Us'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPageScreen(pageTitle: 'About Us'),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Terms & Conditions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPageScreen(pageTitle: 'Terms & Conditions'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
