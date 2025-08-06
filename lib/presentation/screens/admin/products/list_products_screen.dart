import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dukascango/data/env/environment.dart';
import 'package:dukascango/domain/bloc/blocs.dart';
import 'package:dukascango/domain/models/product.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/helpers/helpers.dart';
import 'package:dukascango/presentation/screens/admin/products/add_new_product_screen.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';

class ListProductsScreen extends StatefulWidget {

  @override
  State<ListProductsScreen> createState() => _ListProductsScreenState();
}

class _ListProductsScreenState extends State<ListProductsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductsBloc>(context).add(OnLoadProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state is LoadingProductsState) {
          modalLoading(context);
        }
        if (state is SuccessProductsState) {
          Navigator.pop(context);
          modalSuccess(context, 'Success', () {
            Navigator.pop(context);
            setState(() {});
          });
        }
        if (state is FailureProductsState) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const TextCustom(text: 'List Products', fontSize: 19),
          centerTitle: true,
          leadingWidth: 80,
          elevation: 0,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.arrow_back_ios_new_rounded,
                    color: ColorsDukascango.primaryColor, size: 17),
                TextCustom(
                    text: 'Back', fontSize: 17, color: ColorsDukascango.primaryColor)
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () =>
                    Navigator.push(context, routeDukascango(page: AddNewProductScreen())),
                child: const TextCustom(
                    text: 'Add', fontSize: 17, color: ColorsDukascango.primaryColor))
          ],
        ),
        body: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            if (state.products.isEmpty) {
              return const ShimmerDukascango();
            }
            return _GridViewListProduct(listProducts: state.products);
          },
        ),
      ),
    );
  }
}

class _GridViewListProduct extends StatelessWidget {
  final List<Product> listProducts;

  const _GridViewListProduct({required this.listProducts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      itemCount: listProducts.length,
      itemBuilder: (context, i) {
        final product = listProducts[i];
        return Card(
          child: ListTile(
            leading: product.images.isNotEmpty
                ? Image.network(product.images.first, width: 50, height: 50, fit: BoxFit.cover)
                : const Icon(Icons.image_not_supported),
            title: TextCustom(text: product.name),
            subtitle: TextCustom(text: 'Stock: ${product.stockQuantity ?? 'N/A'}'),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'adjust_stock') {
                  _showAdjustStockDialog(context, product);
                } else if (value == 'delete') {
                  // TODO: Implement delete product
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'adjust_stock',
                  child: Text('Adjust Stock'),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAdjustStockDialog(BuildContext context, Product product) {
    final _formKey = GlobalKey<FormState>();
    final _stockController = TextEditingController(text: product.stockQuantity?.toString() ?? '');
    final _reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adjust Stock'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'New Stock Quantity'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _reasonController,
                  decoration: const InputDecoration(labelText: 'Reason'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a reason';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newStock = int.parse(_stockController.text);
                  final reason = _reasonController.text;
                  BlocProvider.of<ProductsBloc>(context).add(OnAdjustStockEvent(product, newStock, reason));
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}