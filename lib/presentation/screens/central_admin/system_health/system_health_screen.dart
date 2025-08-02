import 'package:dukascango/presentation/screens/central_admin/system_health/api_response_times_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/system_health/database_load_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/system_health/server_performance_screen.dart';
import 'package:flutter/material.dart';

class SystemHealthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('System Health'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Server Performance'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServerPerformanceScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Database Load'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DatabaseLoadScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('API Response Times'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ApiResponseTimesScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
