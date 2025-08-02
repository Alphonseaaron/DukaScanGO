import 'dart:io';
import 'package:dukascango/domain/models/brand.dart';
import 'package:dukascango/domain/models/response/category_all_response.dart';
import 'package:dukascango/domain/services/brand_services.dart';
import 'package:dukascango/domain/services/category_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dukascango/domain/bloc/blocs.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/helpers/helpers.dart';
import 'package:dukascango/domain/models/product.dart';
import 'package:dukascango/presentation/screens/admin/admin_home_screen.dart';
import 'package:dukascango/presentation/screens/admin/products/admin_scan_barcode_screen.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _barcodeController;
  late TextEditingController _costPriceController;
  late TextEditingController _stockQuantityController;
  late TextEditingController _supplierController;
  late TextEditingController _taxRateController;
  late TextEditingController _lowStockThresholdController;

  String? _selectedBrandId;
  String? _selectedCategoryId;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController = TextEditingController(text: widget.product.description);
    _priceController = TextEditingController(text: widget.product.price.toString());
    _barcodeController = TextEditingController(text: widget.product.barcode);
    _costPriceController = TextEditingController(text: widget.product.costPrice?.toString());
    _stockQuantityController = TextEditingController(text: widget.product.stockQuantity?.toString());
    _supplierController = TextEditingController(text: widget.product.supplier);
    _taxRateController = TextEditingController(text: widget.product.taxRate?.toString());
    _lowStockThresholdController = TextEditingController(text: widget.product.lowStockThreshold?.toString());
    _selectedBrandId = widget.product.brandId;
    _selectedCategoryId = widget.product.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _barcodeController.dispose();
    _costPriceController.dispose();
    _stockQuantityController.dispose();
    _supplierController.dispose();
    _taxRateController.dispose();
    _lowStockThresholdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productBloc = BlocProvider.of<ProductsBloc>(context);

    return BlocListener<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state is LoadingProductsState) {
          modalLoading(context);
        }
        if (state is SuccessProductsState) {
          Navigator.pop(context);
          modalSuccess(context, 'Product updated Successfully',
              () => Navigator.pushReplacement(context, routeFrave(page: AdminHomeScreen())));
        }
        if (state is FailureProductsState) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: TextCustom(text: state.error, color: Colors.white), backgroundColor: Colors.red));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const TextCustom(text: 'Edit Product'),
          centerTitle: true,
          leadingWidth: 80,
          leading: TextButton(
            child: const TextCustom(text: 'Cancel', color: ColorsDukascango.primaryColor, fontSize: 17),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          actions: [
            TextButton(
                onPressed: () {
                  if (_keyForm.currentState!.validate()) {
                    final product = widget.product.copyWith(
                      name: _nameController.text,
                      description: _descriptionController.text,
                      price: double.parse(_priceController.text),
                      barcode: _barcodeController.text,
                      costPrice: _costPriceController.text.isNotEmpty ? double.parse(_costPriceController.text) : null,
                      stockQuantity: _stockQuantityController.text.isNotEmpty ? int.parse(_stockQuantityController.text) : null,
                      supplier: _supplierController.text,
                      taxRate: _taxRateController.text.isNotEmpty ? double.parse(_taxRateController.text) : null,
                      lowStockThreshold: _lowStockThresholdController.text.isNotEmpty ? int.parse(_lowStockThresholdController.text) : null,
                      brandId: _selectedBrandId,
                      category: _selectedCategoryId,
                    );
                    productBloc.add(OnUpdateProductEvent(product));
                  }
                },
                child: const TextCustom(text: ' Save ', color: ColorsDukascango.primaryColor))
          ],
        ),
        body: Form(
          key: _keyForm,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            children: [
              const SizedBox(height: 10.0),
              const TextCustom(text: 'Product name'),
              const SizedBox(height: 5.0),
              FormFieldFrave(
                controller: _nameController,
                hintText: 'Product',
                validator: RequiredValidator(errorText: 'Name is required'),
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Product description'),
              const SizedBox(height: 5.0),
              FormFieldFrave(
                controller: _descriptionController,
                maxLine: 5,
                validator: RequiredValidator(errorText: 'Description is required'),
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Price'),
              const SizedBox(height: 5.0),
              FormFieldFrave(
                controller: _priceController,
                hintText: '\$ 0.00',
                keyboardType: TextInputType.number,
                validator: RequiredValidator(errorText: 'Price is required'),
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Barcode'),
              const SizedBox(height: 5.0),
              FormFieldFrave(
                controller: _barcodeController,
                hintText: 'Barcode',
                validator: RequiredValidator(errorText: 'Barcode is required'),
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Cost Price'),
              const SizedBox(height: 5.0),
              FormFieldFrave(
                controller: _costPriceController,
                hintText: '\$ 0.00',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Stock Quantity'),
              const SizedBox(height: 5.0),
              FormFieldFrave(
                controller: _stockQuantityController,
                hintText: '0',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Supplier'),
              const SizedBox(height: 5.0),
              FormFieldFrave(
                controller: _supplierController,
                hintText: 'Supplier',
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Tax Rate'),
              const SizedBox(height: 5.0),
              FormFieldFrave(
                controller: _taxRateController,
                hintText: '0.00',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Low Stock Threshold'),
              const SizedBox(height: 5.0),
              FormFieldFrave(
                controller: _lowStockThresholdController,
                hintText: '0',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Brand'),
              const SizedBox(height: 5.0),
              FutureBuilder<List<Brand>>(
                future: BrandService().getBrands(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButtonFormField<String>(
                      value: _selectedBrandId,
                      items: snapshot.data!
                          .map((brand) => DropdownMenuItem(
                                value: brand.id,
                                child: Text(brand.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBrandId = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Select a brand',
                        border: OutlineInputBorder(),
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Category'),
              const SizedBox(height: 5.0),
              FutureBuilder<List<Category>>(
                future: CategoryServices().getAllCategories(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButtonFormField<String>(
                      value: _selectedCategoryId,
                      items: snapshot.data!
                          .map((category) => DropdownMenuItem(
                                value: category.uidCategory,
                                child: Text(category.category),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryId = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Select a category',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null ? 'Category is required' : null,
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
