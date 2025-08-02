import 'package:dukascango/domain/models/product_placement.dart';
import 'package:dukascango/domain/services/product_placement_services.dart';
import 'package:dukascango/presentation/screens/central_admin/brand_deal_management/create_product_placement_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/brand_deal_management/product_placement_details_screen.dart';
import 'package:flutter/material.dart';

class ProductPlacementListScreen extends StatefulWidget {
  @override
  _ProductPlacementListScreenState createState() =>
      _ProductPlacementListScreenState();
}

class _ProductPlacementListScreenState
    extends State<ProductPlacementListScreen> {
  late Future<List<ProductPlacement>> _productPlacements;

  @override
  void initState() {
    super.initState();
    _productPlacements = ProductPlacementService().getProductPlacements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Placements'),
      ),
      body: FutureBuilder<List<ProductPlacement>>(
        future: _productPlacements,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No product placements found.'));
          } else {
            final productPlacements = snapshot.data!;
            return ListView.builder(
              itemCount: productPlacements.length,
              itemBuilder: (context, index) {
                final productPlacement = productPlacements[index];
                return ListTile(
                  title: Text(productPlacement.name),
                  subtitle: Text(productPlacement.placementType),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductPlacementDetailsScreen(
                          productPlacement: productPlacement,
                        ),
                      ),
                    ).then((_) {
                      // Refresh the list when coming back
                      setState(() {
                        _productPlacements =
                            ProductPlacementService().getProductPlacements();
                      });
                    });
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
              builder: (context) => CreateProductPlacementScreen(),
            ),
          ).then((_) {
            // Refresh the list when coming back
            setState(() {
              _productPlacements =
                  ProductPlacementService().getProductPlacements();
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
