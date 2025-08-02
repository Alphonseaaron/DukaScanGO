import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dukascango/domain/bloc/auth/auth_bloc.dart';
import 'package:meta/meta.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dukascango/domain/models/product.dart';
import 'package:dukascango/domain/services/products_services.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsServices _productsServices = ProductsServices();
  final AuthBloc authBloc;

  ProductsBloc({required this.authBloc}) : super(const ProductsState()) {
    on<OnAddNewProductEvent>(_onAddNewProduct);
    on<OnUpdateProductEvent>(_onUpdateProduct);
    on<OnDeleteProductEvent>(_onDeleteProduct);
    on<OnLoadProductsEvent>(_onLoadProducts);
    on<OnSelectMultipleImagesEvent>(_onSelectMultipleImages);
    on<OnUnSelectMultipleImagesEvent>(_onUnSelectMultipleImages);
    on<OnAdjustStockEvent>(_onAdjustStock);
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
      await _productsServices.addProduct(event.product, event.images);
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

  Future<void> _onAdjustStock(
      OnAdjustStockEvent event, Emitter<ProductsState> emit) async {
    try {
      emit(LoadingProductsState());
      final user = authBloc.state.user;
      if (user != null) {
        await _productsServices.adjustStock(
            event.product, event.newStock, event.reason, user.uid);
        final products = await _productsServices.getProducts();
        emit(SuccessProductsState());
        emit(state.copyWith(products: products));
      } else {
        emit(FailureProductsState('User not authenticated'));
      }
    } catch (e) {
      emit(FailureProductsState(e.toString()));
    }
  }
}
