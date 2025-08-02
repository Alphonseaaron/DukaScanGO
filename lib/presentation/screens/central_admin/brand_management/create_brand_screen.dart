import 'dart:io';

import 'package:dukascango/domain/models/brand.dart';
import 'package:dukascango/domain/services/brand_services.dart';
import 'package:dukascango/presentation/helpers/modal_loading.dart';
import 'package:dukascango/presentation/helpers/modal_success.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateBrandScreen extends StatefulWidget {
  @override
  _CreateBrandScreenState createState() => _CreateBrandScreenState();
}

class _CreateBrandScreenState extends State<CreateBrandScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Brand'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
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
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(_image == null ? 'No image selected' : _image!.name),
                  ),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Pick Logo'),
                  ),
                ],
              ),
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Image.file(
                    File(_image!.path),
                    height: 100,
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    modalLoading(context);
                    final brand = Brand(name: _nameController.text);
                    await BrandService().addBrand(brand, _image);
                    Navigator.pop(context);
                    modalSuccess(context, 'Brand created successfully!',
                        onPressed: () => Navigator.pop(context));
                  }
                },
                child: Text('Create Brand'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
