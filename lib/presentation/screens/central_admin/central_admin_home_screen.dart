import 'package:dukascango/presentation/screens/central_admin/brand_deal_management/brand_deal_management_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/crm_support/crm_support_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/feature_placeholder_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/featured_store_management/featured_store_list_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/financial_management/financial_management_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/platform_settings/platform_settings_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/rbac/rbac_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/rewards_gamification/rewards_gamification_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/system_health/system_health_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/user_management/user_list_screen.dart';
import 'package:flutter/material.dart';

class CentralAdminHomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _features = [
    {'title': 'Dashboard', 'icon': Icons.dashboard, 'screen': FeaturePlaceholderScreen(title: 'Dashboard')},
    {'title': 'User Management', 'icon': Icons.people, 'screen': UserListScreen()},
    {'title': 'Financial Management', 'icon': Icons.account_balance_wallet, 'screen': FinancialManagementScreen()},
    {'title': 'CRM & Support', 'icon': Icons.support_agent, 'screen': CrmSupportScreen()},
    {'title': 'Rewards & Gamification', 'icon': Icons.card_giftcard, 'screen': RewardsGamificationScreen()},
    {'title': 'Brand Deal Management', 'icon': Icons.business, 'screen': BrandDealManagementScreen()},
    {'title': 'Featured Stores', 'icon': Icons.store, 'screen': FeaturedStoreListScreen()},
    {'title': 'Platform Settings', 'icon': Icons.settings, 'screen': PlatformSettingsScreen()},
    {'title': 'System Health', 'icon': Icons.healing, 'screen': SystemHealthScreen()},
    {'title': 'Internal RBAC', 'icon': Icons.security, 'screen': RbacScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Super Admin Panel'),
      ),
      body: ListView.builder(
        itemCount: _features.length,
        itemBuilder: (context, index) {
          final feature = _features[index];
          return ListTile(
            leading: Icon(feature['icon']),
            title: Text(feature['title']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => feature['screen'],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
