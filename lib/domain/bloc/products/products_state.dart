part of 'products_bloc.dart';

@immutable
class ProductsState {
  final List<Product> products;
  final List<XFile>? images;
  final String? searchProduct;

  const ProductsState({
    this.products = const [],
    this.images,
    this.searchProduct,
  });

  ProductsState copyWith({
    List<Product>? products,
    List<XFile>? images,
    String? searchProduct,
  }) =>
      ProductsState(
        products: products ?? this.products,
        images: images ?? this.images,
        searchProduct: searchProduct ?? this.searchProduct,
      );
}


class LoadingProductsState extends ProductsState {}

class SuccessProductsState extends ProductsState {}

class FailureProductsState extends ProductsState {
  final String error;

  FailureProductsState(this.error);
}