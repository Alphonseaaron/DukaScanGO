import 'package:dukascango/domain/models/featured_store.dart';
import 'package:dukascango/domain/models/user.dart';
import 'package:dukascango/domain/services/featured_store_service.dart';
import 'package:dukascango/domain/services/store_service.dart';
import 'package:dukascango/presentation/helpers/modal_loading.dart';
import 'package:dukascango/presentation/helpers/modal_success.dart';
import 'package:flutter/material.dart';

class CreateFeaturedStoreScreen extends StatefulWidget {
  @override
  _CreateFeaturedStoreScreenState createState() =>
      _CreateFeaturedStoreScreenState();
}

class _CreateFeaturedStoreScreenState extends State<CreateFeaturedStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedStoreId;
  String _selectedTier = 'bronze';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Featured Store'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              FutureBuilder<List<User>>(
                future: StoreService().getStores(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButtonFormField<String>(
                      value: _selectedStoreId,
                      items: snapshot.data!
                          .map((store) => DropdownMenuItem(
                                value: store.uid,
                                child: Text(store.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedStoreId = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Select a store',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null ? 'Please select a store' : null,
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedTier,
                items: [
                  DropdownMenuItem(value: 'bronze', child: Text('Bronze')),
                  DropdownMenuItem(value: 'silver', child: Text('Silver')),
                  DropdownMenuItem(value: 'gold', child: Text('Gold')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedTier = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Tier'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    modalLoading(context);
                    final featuredStore = FeaturedStore(
                      storeId: _selectedStoreId!,
                      tier: _selectedTier,
                    );
                    await FeaturedStoreService()
                        .addFeaturedStore(featuredStore);
                    Navigator.pop(context);
                    modalSuccess(
                        context, 'Featured store created successfully!',
                        onPressed: () => Navigator.pop(context));
                  }
                },
                child: Text('Create Featured Store'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
