import 'package:dukascango/domain/models/featured_store.dart';
import 'package:dukascango/domain/services/featured_store_service.dart';
import 'package:dukascango/presentation/screens/central_admin/featured_store_management/create_featured_store_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/featured_store_management/edit_featured_store_screen.dart';
import 'package:flutter/material.dart';

class FeaturedStoreListScreen extends StatefulWidget {
  @override
  _FeaturedStoreListScreenState createState() =>
      _FeaturedStoreListScreenState();
}

class _FeaturedStoreListScreenState extends State<FeaturedStoreListScreen> {
  late Future<List<FeaturedStore>> _featuredStores;

  @override
  void initState() {
    super.initState();
    _featuredStores = FeaturedStoreService().getFeaturedStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Featured Stores'),
      ),
      body: FutureBuilder<List<FeaturedStore>>(
        future: _featuredStores,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No featured stores found.'));
          } else {
            final featuredStores = snapshot.data!;
            return ListView.builder(
              itemCount: featuredStores.length,
              itemBuilder: (context, index) {
                final featuredStore = featuredStores[index];
                return ListTile(
                  title: Text(featuredStore.storeId),
                  subtitle: Text(featuredStore.tier),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditFeaturedStoreScreen(
                          featuredStore: featuredStore,
                        ),
                      ),
                    ).then((_) {
                      // Refresh the list when coming back
                      setState(() {
                        _featuredStores =
                            FeaturedStoreService().getFeaturedStores();
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
              builder: (context) => CreateFeaturedStoreScreen(),
            ),
          ).then((_) {
            // Refresh the list when coming back
            setState(() {
              _featuredStores =
                  FeaturedStoreService().getFeaturedStores();
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
