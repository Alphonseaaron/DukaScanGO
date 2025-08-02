import 'package:dukascango/domain/models/product_placement.dart';
import 'package:dukascango/domain/services/product_placement_services.dart';
import 'package:dukascango/presentation/helpers/modal_loading.dart';
import 'package:dukascango/presentation/helpers/modal_success.dart';
import 'package:flutter/material.dart';

class CreateProductPlacementScreen extends StatefulWidget {
  @override
  _CreateProductPlacementScreenState createState() =>
      _CreateProductPlacementScreenState();
}

class _CreateProductPlacementScreenState
    extends State<CreateProductPlacementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _productIdsController = TextEditingController();
  String _selectedPlacementType = 'soft_recommendation';
  final _rules = <Map<String, dynamic>>[];

  void _addRule() {
    setState(() {
      _rules.add({'type': 'category', 'operator': 'equals', 'value': ''});
    });
  }

  void _removeRule(int index) {
    setState(() {
      _rules.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product Placement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _productIdsController,
                decoration:
                    InputDecoration(labelText: 'Product IDs (comma separated)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter at least one product ID';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedPlacementType,
                items: [
                  DropdownMenuItem(
                      value: 'soft_recommendation',
                      child: Text('Soft Recommendation')),
                  DropdownMenuItem(
                      value: 'aggressive_placement',
                      child: Text('Aggressive Placement')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPlacementType = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Placement Type'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rules', style: Theme.of(context).textTheme.headline6),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addRule,
                  ),
                ],
              ),
              ..._rules.asMap().entries.map((entry) {
                final index = entry.key;
                final rule = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: rule['type'],
                        items: [
                          DropdownMenuItem(
                              value: 'category', child: Text('Category')),
                          DropdownMenuItem(
                              value: 'minPrice', child: Text('Min Price')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _rules[index]['type'] = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: rule['operator'],
                        items: [
                          DropdownMenuItem(
                              value: 'equals', child: Text('Equals')),
                          DropdownMenuItem(
                              value: 'greaterThan',
                              child: Text('Greater Than')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _rules[index]['operator'] = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        initialValue: rule['value'],
                        onChanged: (value) {
                          _rules[index]['value'] = value;
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => _removeRule(index),
                    ),
                  ],
                );
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    modalLoading(context);
                    final productIds = _productIdsController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    final productPlacement = ProductPlacement(
                      name: _nameController.text,
                      description: _descriptionController.text,
                      productIds: productIds,
                      placementType: _selectedPlacementType,
                      rules: _rules,
                    );
                    await ProductPlacementService()
                        .addProductPlacement(productPlacement);
                    Navigator.pop(context);
                    modalSuccess(
                        context, 'Product placement created successfully!',
                        onPressed: () => Navigator.pop(context));
                  }
                },
                child: Text('Create Product Placement'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
