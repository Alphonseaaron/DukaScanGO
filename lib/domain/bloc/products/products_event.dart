part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent {}

class OnLoadProductsEvent extends ProductsEvent {}

class OnAddNewProductEvent extends ProductsEvent {
  final Product product;
  final List<XFile> images;

  OnAddNewProductEvent(this.product, this.images);
}

class OnUpdateProductEvent extends ProductsEvent {
  final Product product;

  OnUpdateProductEvent(this.product);
}

class OnDeleteProductEvent extends ProductsEvent {
  final String id;

  OnDeleteProductEvent(this.id);
}

class OnSelectMultipleImagesEvent extends ProductsEvent {
  final List<XFile> images;

  OnSelectMultipleImagesEvent(this.images);
}

class OnUnSelectMultipleImagesEvent extends ProductsEvent {}

class OnAdjustStockEvent extends ProductsEvent {
  final Product product;
  final int newStock;
  final String reason;

  OnAdjustStockEvent(this.product, this.newStock, this.reason);
}

class OnSearchProductEvent extends ProductsEvent {
  final String search;

  OnSearchProductEvent(this.search);
}
