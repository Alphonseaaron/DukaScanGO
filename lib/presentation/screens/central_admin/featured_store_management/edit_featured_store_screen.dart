import 'package:dukascango/domain/models/featured_store.dart';
import 'package:dukascango/domain/models/user.dart';
import 'package:dukascango/domain/services/featured_store_service.dart';
import 'package:dukascango/domain/services/store_service.dart';
import 'package:dukascango/presentation/helpers/modal_loading.dart';
import 'package:dukascango/presentation/helpers/modal_success.dart';
import 'package:flutter/material.dart';

class EditFeaturedStoreScreen extends StatefulWidget {
  final FeaturedStore featuredStore;

  const EditFeaturedStoreScreen({Key? key, required this.featuredStore})
      : super(key: key);

  @override
  _EditFeaturedStoreScreenState createState() =>
      _EditFeaturedStoreScreenState();
}

class _EditFeaturedStoreScreenState extends State<EditFeaturedStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedStoreId;
  late String _selectedTier;

  @override
  void initState() {
    super.initState();
    _selectedStoreId = widget.featuredStore.storeId;
    _selectedTier = widget.featuredStore.tier;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Featured Store'),
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
                          _selectedStoreId = value!;
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
                    final updatedFeaturedStore = widget.featuredStore.copyWith(
                      storeId: _selectedStoreId,
                      tier: _selectedTier,
                    );
                    await FeaturedStoreService()
                        .updateFeaturedStore(updatedFeaturedStore);
                    Navigator.pop(context); // Close loading modal
                    modalSuccess(
                        context, 'Featured store updated successfully!',
                        onPressed: () {
                      Navigator.pop(context); // Close success modal
                      Navigator.pop(context, true); // Go back to details screen
                    });
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
