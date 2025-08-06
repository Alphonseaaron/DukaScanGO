import 'package:flutter/material.dart';
import 'package:dukascango/presentation/screens/wholesaler/wholesaler_dashboard_screen.dart';
import 'package:dukascango/presentation/screens/wholesaler/wholesaler_orders_screen.dart';
import 'package:dukascango/presentation/screens/wholesaler/wholesaler_products_screen.dart';
import 'package:dukascango/presentation/screens/wholesaler/wholesaler_profile_screen.dart';
import 'package:dukascango/presentation/screens/wholesaler/wholesaler_staff_screen.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';

class WholesalerHomeScreen extends StatefulWidget {
  @override
  _WholesalerHomeScreenState createState() => _WholesalerHomeScreenState();
}

class _WholesalerHomeScreenState extends State<WholesalerHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    WholesalerDashboardScreen(),
    WholesalerProductsScreen(),
    WholesalerOrdersScreen(),
    WholesalerProfileScreen(),
    WholesalerStaffScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: ColorsFrave.primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Staff',
          ),
        ],
      ),
    );
  }
}
