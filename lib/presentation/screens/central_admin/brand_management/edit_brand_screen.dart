import 'dart:io';

import 'package:dukascango/domain/models/brand.dart';
import 'package:dukascango/domain/services/brand_services.dart';
import 'package:dukascango/presentation/helpers/modal_loading.dart';
import 'package:dukascango/presentation/helpers/modal_success.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditBrandScreen extends StatefulWidget {
  final Brand brand;

  const EditBrandScreen({Key? key, required this.brand}) : super(key: key);

  @override
  _EditBrandScreenState createState() => _EditBrandScreenState();
}

class _EditBrandScreenState extends State<EditBrandScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  XFile? _image;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.brand.name);
  }

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
        title: Text('Edit Brand'),
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
                    child: Text(_image == null ? 'No new image selected' : _image!.name),
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
                )
              else if (widget.brand.logoUrl != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Image.network(
                    widget.brand.logoUrl!,
                    height: 100,
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    modalLoading(context);
                    final updatedBrand = widget.brand.copyWith(
                      name: _nameController.text,
                    );
                    await BrandService().updateBrand(updatedBrand, _image);
                    Navigator.pop(context); // Close loading modal
                    modalSuccess(context, 'Brand updated successfully!',
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
