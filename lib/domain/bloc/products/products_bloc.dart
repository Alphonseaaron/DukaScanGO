import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dukascango/domain/models/product.dart';
import 'package:dukascango/domain/services/products_services.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsServices _productsServices = ProductsServices();

  ProductsBloc() : super(const ProductsState()) {
    on<OnAddNewProductEvent>(_onAddNewProduct);
    on<OnUpdateProductEvent>(_onUpdateProduct);
    on<OnDeleteProductEvent>(_onDeleteProduct);
    on<OnLoadProductsEvent>(_onLoadProducts);
    on<OnSelectMultipleImagesEvent>(_onSelectMultipleImages);
    on<OnUnSelectMultipleImagesEvent>(_onUnSelectMultipleImages);
  }

  Future<void> _onLoadProducts(
      OnLoadProductsEvent event, Emitter<ProductsState> emit) async {
    try {
      emit(LoadingProductsState());
      final products = await _productsServices.getProducts();
      emit(state.copyWith(products: products));
    } catch (e) {
      emit(FailureProductsState(e.toString()));
    }
  }

  Future<void> _onAddNewProduct(
      OnAddNewProductEvent event, Emitter<ProductsState> emit) async {
    try {
      emit(LoadingProductsState());
      final imageUrls = await _productsServices.uploadImages(event.images);
      final productWithImages = event.product.copyWith(images: imageUrls);
      await _productsServices.addProduct(productWithImages, event.images);
      final products = await _productsServices.getProducts();
      emit(SuccessProductsState());
      emit(state.copyWith(products: products));
    } catch (e) {
      emit(FailureProductsState(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
      OnUpdateProductEvent event, Emitter<ProductsState> emit) async {
    try {
      emit(LoadingProductsState());
      await _productsServices.updateProduct(event.product);
      final products = await _productsServices.getProducts();
      emit(SuccessProductsState());
      emit(state.copyWith(products: products));
    } catch (e) {
      emit(FailureProductsState(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
      OnDeleteProductEvent event, Emitter<ProductsState> emit) async {
    try {
      emit(LoadingProductsState());
      await _productsServices.deleteProduct(event.id);
      final products = await _productsServices.getProducts();
      emit(SuccessProductsState());
      emit(state.copyWith(products: products));
    } catch (e) {
      emit(FailureProductsState(e.toString()));
    }
  }

  Future<void> _onSelectMultipleImages(
      OnSelectMultipleImagesEvent event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(images: event.images));
  }

  Future<void> _onUnSelectMultipleImages(
      OnUnSelectMultipleImagesEvent event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(images: []));
  }
}
