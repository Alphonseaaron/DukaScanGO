import 'package:dukascango/presentation/screens/central_admin/brand_deal_management/campaign_list_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/brand_deal_management/product_placement_list_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/brand_management/brand_list_screen.dart';
import 'package:flutter/material.dart';

class BrandDealManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brand Deal Management'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Manage Brands'),
            leading: Icon(Icons.business),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BrandListScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Manage Campaigns'),
            leading: Icon(Icons.campaign),
            onTap: () {
              // This should ideally ask for a brand first, but for now, we'll just navigate to a screen
              // that expects a brandId. This is a temporary solution.
              // A better solution would be to select a brand from the BrandListScreen and then navigate to the CampaignListScreen.
              // For now, we will pass a hardcoded brandId.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CampaignListScreen(brandId: 'temp_brand_id'),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Product Placement'),
            leading: Icon(Icons.place),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPlacementListScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
