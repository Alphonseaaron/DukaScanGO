import 'dart:io';
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

class AddNewProductScreen extends StatefulWidget {
  @override
  _AddNewProductScreenState createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _barcodeController;
  late TextEditingController _costPriceController;
  late TextEditingController _stockQuantityController;
  late TextEditingController _supplierController;
  late TextEditingController _taxRateController;
  late TextEditingController _lowStockThresholdController;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _barcodeController = TextEditingController();
    _costPriceController = TextEditingController();
    _stockQuantityController = TextEditingController();
    _supplierController = TextEditingController();
    _taxRateController = TextEditingController();
    _lowStockThresholdController = TextEditingController();
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
          modalSuccess(context, 'Product added Successfully',
              () => Navigator.pushReplacement(context, routeDukascango(page: AdminHomeScreen())));
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
          title: const TextCustom(text: 'Add New Product'),
          centerTitle: true,
          leadingWidth: 80,
          leading: TextButton(
            child: const TextCustom(text: 'Cancel', color: ColorsDukascango.primaryColor, fontSize: 17),
            onPressed: () {
              Navigator.pop(context);
              productBloc.add(OnUnselectCategoryEvent());
              productBloc.add(OnUnSelectMultipleImagesEvent());
            },
          ),
          elevation: 0,
          actions: [
            TextButton(
                onPressed: () {
                  if (_keyForm.currentState!.validate()) {
                    final product = Product(
                      name: _nameController.text,
                      description: _descriptionController.text,
                      price: double.parse(_priceController.text),
                      barcode: _barcodeController.text,
                      costPrice: _costPriceController.text.isNotEmpty ? double.parse(_costPriceController.text) : null,
                      stockQuantity: _stockQuantityController.text.isNotEmpty ? int.parse(_stockQuantityController.text) : null,
                      supplier: _supplierController.text,
                      taxRate: _taxRateController.text.isNotEmpty ? double.parse(_taxRateController.text) : null,
                      lowStockThreshold: _lowStockThresholdController.text.isNotEmpty ? int.parse(_lowStockThresholdController.text) : null,
                      images: [],
                      category: 'default', // TODO: Add category selection
                    );
                    productBloc.add(OnAddNewProductEvent(
                      product,
                      productBloc.state.images!,
                    ));
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
              FormFieldDukascango(
                controller: _nameController,
                hintText: 'Product',
                validator: RequiredValidator(errorText: 'Name is required'),
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Product description'),
              const SizedBox(height: 5.0),
              FormFieldDukascango(
                controller: _descriptionController,
                maxLine: 5,
                validator: RequiredValidator(errorText: 'Description is required'),
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Price'),
              const SizedBox(height: 5.0),
              FormFieldDukascango(
                controller: _priceController,
                hintText: '\$ 0.00',
                keyboardType: TextInputType.number,
                validator: RequiredValidator(errorText: 'Price is required'),
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Barcode'),
              const SizedBox(height: 5.0),
              FormFieldDukascango(
                controller: _barcodeController,
                hintText: 'Barcode',
                validator: RequiredValidator(errorText: 'Barcode is required'),
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Cost Price'),
              const SizedBox(height: 5.0),
              FormFieldDukascango(
                controller: _costPriceController,
                hintText: '\$ 0.00',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Stock Quantity'),
              const SizedBox(height: 5.0),
              FormFieldDukascango(
                controller: _stockQuantityController,
                hintText: '0',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Supplier'),
              const SizedBox(height: 5.0),
              FormFieldDukascango(
                controller: _supplierController,
                hintText: 'Supplier',
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Tax Rate'),
              const SizedBox(height: 5.0),
              FormFieldDukascango(
                controller: _taxRateController,
                hintText: '0.00',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Low Stock Threshold'),
              const SizedBox(height: 5.0),
              FormFieldDukascango(
                controller: _lowStockThresholdController,
                hintText: '0',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10.0),
              BtnDukascango(
                text: 'Scan Barcode',
                onPressed: () async {
                  final barcode = await Navigator.push<String>(context, routeFrave(page: AdminScanBarcodeScreen()));
                  if (barcode != null) {
                    _barcodeController.text = barcode;
                  }
                },
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Pictures'),
              const SizedBox(height: 10.0),
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final List<XFile>? images = await _picker.pickMultiImage();
                  if (images != null) productBloc.add(OnSelectMultipleImagesEvent(images));
                },
                child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8.0)),
                  child: BlocBuilder<ProductsBloc, ProductsState>(
                      builder: (context, state) => state.images != null
                          ? ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                              scrollDirection: Axis.horizontal,
                              itemCount: state.images?.length,
                              itemBuilder: (_, i) => Container(
                                height: 100,
                                width: 120,
                                margin: const EdgeInsets.only(right: 10.0),
                                decoration: BoxDecoration(
                                    image: DecorationImage(image: FileImage(File(state.images![i].path)), fit: BoxFit.cover)),
                              ))
                          : const Icon(Icons.wallpaper_rounded, size: 80, color: Colors.grey)),
                ),
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Category'),
              const SizedBox(height: 5.0),
              FormFieldDukascango(
                hintText: 'Category',
                // TODO: Implement category selection
              ),
            ],
          ),
        ),
      ),
    );
  }
}