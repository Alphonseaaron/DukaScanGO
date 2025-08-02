import 'package:dukascango/domain/models/product_placement.dart';
import 'package:dukascango/domain/services/product_placement_services.dart';
import 'package:dukascango/presentation/helpers/modal_delete.dart';
import 'package:dukascango/presentation/helpers/modal_loading.dart';
import 'package:dukascango/presentation/helpers/modal_success.dart';
import 'package:dukascango/presentation/screens/central_admin/brand_deal_management/edit_product_placement_screen.dart';
import 'package:flutter/material.dart';

class ProductPlacementDetailsScreen extends StatefulWidget {
  final ProductPlacement productPlacement;

  const ProductPlacementDetailsScreen(
      {Key? key, required this.productPlacement})
      : super(key: key);

  @override
  _ProductPlacementDetailsScreenState createState() =>
      _ProductPlacementDetailsScreenState();
}

class _ProductPlacementDetailsScreenState
    extends State<ProductPlacementDetailsScreen> {
  late ProductPlacement _productPlacement;

  @override
  void initState() {
    super.initState();
    _productPlacement = widget.productPlacement;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Placement Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductPlacementScreen(
                    productPlacement: _productPlacement,
                  ),
                ),
              ).then((value) {
                if (value == true) {
                  // Reload the data if it was updated
                  ProductPlacementService()
                      .getProductPlacementById(_productPlacement.id!)
                      .then((updatedProductPlacement) {
                    if (updatedProductPlacement != null) {
                      setState(() {
                        _productPlacement = updatedProductPlacement;
                      });
                    }
                  });
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              modalDelete(
                  context,
                  'Delete Product Placement',
                  'Are you sure you want to delete this product placement?',
                  () async {
                modalLoading(context);
                await ProductPlacementService()
                    .deleteProductPlacement(_productPlacement.id!);
                Navigator.pop(context);
                modalSuccess(context, 'Product placement deleted successfully!',
                    onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true); // Go back to the list
                });
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${_productPlacement.name}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Description: ${_productPlacement.description}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Placement Type: ${_productPlacement.placementType}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Products:', style: TextStyle(fontSize: 18)),
            ..._productPlacement.productIds
                .map((productId) => Text('- $productId'))
                .toList(),
          ],
        ),
      ),
    );
  }
}
