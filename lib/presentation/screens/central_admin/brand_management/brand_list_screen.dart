import 'package:dukascango/domain/models/brand.dart';
import 'package:dukascango/domain/services/brand_services.dart';
import 'package:dukascango/presentation/screens/central_admin/brand_management/brand_details_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/brand_management/create_brand_screen.dart';
import 'package:flutter/material.dart';

class BrandListScreen extends StatefulWidget {
  @override
  _BrandListScreenState createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {
  late Future<List<Brand>> _brands;

  @override
  void initState() {
    super.initState();
    _brands = BrandService().getBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brand Management'),
      ),
      body: FutureBuilder<List<Brand>>(
        future: _brands,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No brands found.'));
          } else {
            final brands = snapshot.data!;
            return ListView.builder(
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                return ListTile(
                  leading: brand.logoUrl != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(brand.logoUrl!),
                        )
                      : CircleAvatar(
                          child: Icon(Icons.business),
                        ),
                  title: Text(brand.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BrandDetailsScreen(brand: brand),
                      ),
                    ).then((_) {
                      // Refresh the list when coming back
                      setState(() {
                        _brands = BrandService().getBrands();
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
              builder: (context) => CreateBrandScreen(),
            ),
          ).then((_) {
            // Refresh the list when coming back
            setState(() {
              _brands = BrandService().getBrands();
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
