import 'package:dukascango/presentation/screens/central_admin/rbac/create_role_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/rbac/role_details_screen.dart';
import 'package:flutter/material.dart';

class RbacScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Fetch real data
    final roles = [
      {'id': '1', 'name': 'Super Admin'},
      {'id': '2', 'name': 'Admin'},
      {'id': '3', 'name': 'Client'},
      {'id': '4', 'name': 'Store Owner'},
      {'id': '5', 'name': 'Wholesaler'},
      {'id': '6', 'name': 'Delivery'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Roles & Permissions'),
      ),
      body: ListView.builder(
        itemCount: roles.length,
        itemBuilder: (context, index) {
          final role = roles[index];
          return ListTile(
            title: Text(role['name']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoleDetailsScreen(role: role),
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
              builder: (context) => CreateRoleScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
