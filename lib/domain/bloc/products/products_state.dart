part of 'products_bloc.dart';

@immutable
class ProductsState {
  final List<Product> products;
  final List<Product> searchedProducts;
  final List<XFile>? images;
  final String? searchProduct;
  final String? idCategory;
  final String? nameCategory;

  const ProductsState({
    this.products = const [],
    this.searchedProducts = const [],
    this.images,
    this.searchProduct,
    this.idCategory,
    this.nameCategory,
  });

  ProductsState copyWith({
    List<Product>? products,
    List<Product>? searchedProducts,
    List<XFile>? images,
    String? searchProduct,
    String? idCategory,
    String? nameCategory,
  }) =>
      ProductsState(
        products: products ?? this.products,
        searchedProducts: searchedProducts ?? this.searchedProducts,
        images: images ?? this.images,
        searchProduct: searchProduct ?? this.searchProduct,
        idCategory: idCategory ?? this.idCategory,
        nameCategory: nameCategory ?? this.nameCategory,
      );
}


class LoadingProductsState extends ProductsState {}

class SuccessProductsState extends ProductsState {}

class FailureProductsState extends ProductsState {
  final String error;

  FailureProductsState(this.error);
}