import 'package:dukascango/domain/models/brand.dart';
import 'package:dukascango/domain/services/brand_services.dart';
import 'package:dukascango/presentation/helpers/modal_delete.dart';
import 'package:dukascango/presentation/helpers/modal_loading.dart';
import 'package:dukascango/presentation/helpers/modal_success.dart';
import 'package:dukascango/presentation/screens/central_admin/brand_deal_management/brand_analytics_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/brand_management/edit_brand_screen.dart';
import 'package:flutter/material.dart';

class BrandDetailsScreen extends StatefulWidget {
  final Brand brand;

  const BrandDetailsScreen({Key? key, required this.brand}) : super(key: key);

  @override
  _BrandDetailsScreenState createState() => _BrandDetailsScreenState();
}

class _BrandDetailsScreenState extends State<BrandDetailsScreen> {
  late Brand _brand;

  @override
  void initState() {
    super.initState();
    _brand = widget.brand;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brand Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.analytics),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BrandAnalyticsScreen(brandId: _brand.id!),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditBrandScreen(brand: _brand),
                ),
              ).then((value) {
                if (value == true) {
                  // Reload the brand data if it was updated
                  BrandService().getBrandById(_brand.id!).then((updatedBrand) {
                    if (updatedBrand != null) {
                      setState(() {
                        _brand = updatedBrand;
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
              modalDelete(context, 'Delete Brand',
                  'Are you sure you want to delete this brand?', () async {
                modalLoading(context);
                await BrandService().deleteBrand(_brand.id!);
                Navigator.pop(context);
                modalSuccess(context, 'Brand deleted successfully!',
                    onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true); // Go back to brand list
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
            if (_brand.logoUrl != null)
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_brand.logoUrl!),
                ),
              ),
            SizedBox(height: 20),
            Text('Name: ${_brand.name}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
