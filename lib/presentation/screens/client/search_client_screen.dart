import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dukascango/data/env/environment.dart';
import 'package:dukascango/domain/bloc/blocs.dart';
import 'package:dukascango/domain/models/product.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/screens/client/client_home_screen.dart';
import 'package:dukascango/presentation/screens/client/details_product_screen.dart';
import 'package:dukascango/domain/services/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dukascango/presentation/components/bottom_navigation_dukascango.dart';
import 'package:dukascango/domain/bloc/products/products_bloc.dart';

class SearchClientScreen extends StatefulWidget {
  @override
  _SearchClientScreenState createState() => _SearchClientScreenState();
}

class _SearchClientScreenState extends State<SearchClientScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.clear();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productBloc = BlocProvider.of<ProductsBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pushReplacement(
                        context, routeDukascango(page: ClientHomeScreen())),
                    child: Container(
                      height: 44,
                      child: Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: 44,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8.0)),
                      child: TextFormField(
                        controller: _searchController,
                        onChanged: (value) {
                          productBloc.add(OnSearchProductEvent(value));
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search products',
                            hintStyle: GoogleFonts.getFont('Inter',
                                color: Colors.grey)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              BlocBuilder<ProductsBloc, ProductsState>(
                builder: (_, state) {
                  if (state.searchedProducts.isEmpty) {
                    return _HistorySearch();
                  }
                  return _ListProductSearch(listProduct: state.searchedProducts);
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationFrave(1),
    );
  }
}

class _ListProductSearch extends StatelessWidget {
  final List<Product> listProduct;

  const _ListProductSearch({required this.listProduct});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listProduct.length,
        itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    routeDukascango(
                        page: DetailsProductScreen(product: listProduct[i]))),
                child: Container(
                  height: 90,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Row(
                    children: [
                      Container(
                        width: 90,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                scale: 8,
                                image: NetworkImage(listProduct[i].images[0]))),
                      ),
                      const SizedBox(width: 5.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextCustom(text: listProduct[i].name),
                            const SizedBox(height: 5.0),
                            TextCustom(
                                text: '\$ ${listProduct[i].price}',
                                color: Colors.grey),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}

class _HistorySearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const TextCustom(
            text: 'RECENT SEARCH', fontSize: 16, color: Colors.grey),
        const SizedBox(height: 10.0),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          minLeadingWidth: 20,
          leading: const Icon(Icons.history),
          title: const TextCustom(text: 'Burger', color: Colors.grey),
        )
      ],
    );
  }
}
