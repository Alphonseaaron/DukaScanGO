import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dukascango/domain/models/product.dart';
import 'package:dukascango/domain/services/products_services.dart';
import 'package:dukascango/domain/services/category_services.dart';

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
    on<OnAdjustStockEvent>(_onAdjustStock);
    on<OnSearchProductEvent>(_onSearchProduct);
    on<OnUpdateStatusProductEvent>(_onUpdateStatusProduct);
    on<OnSelectCategoryEvent>(_onSelectCategory);
    on<OnAddNewCategoryEvent>(_onAddNewCategory);
    on<OnUnSelectCategoryEvent>(_onUnSelectCategory);
  }

  Future<void> _onSelectCategory(
      OnSelectCategoryEvent event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(idCategory: event.id, nameCategory: event.name));
  }

  Future<void> _onAddNewCategory(
      OnAddNewCategoryEvent event, Emitter<ProductsState> emit) async {
    try {
      emit(LoadingProductsState());
      await categoryServices.addNewCategory(event.name, event.description);
      emit(SuccessProductsState());
    } catch (e) {
      emit(FailureProductsState(e.toString()));
    }
  }

  Future<void> _onUnSelectCategory(
      OnUnSelectCategoryEvent event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(idCategory: '', nameCategory: ''));
  }

  Future<void> _onUpdateStatusProduct(
      OnUpdateStatusProductEvent event, Emitter<ProductsState> emit) async {
    try {
      emit(LoadingProductsState());
      await _productsServices.updateProductStatus(event.id, event.status);
      final products = await _productsServices.getProducts();
      emit(SuccessProductsState());
      emit(state.copyWith(products: products));
    } catch (e) {
      emit(FailureProductsState(e.toString()));
    }
  }

  Future<void> _onSearchProduct(
      OnSearchProductEvent event, Emitter<ProductsState> emit) async {
    if (event.search.isEmpty) {
      emit(state.copyWith(searchedProducts: []));
      return;
    }
    final products = state.products
        .where((p) =>
            p.name.toLowerCase().contains(event.search.toLowerCase()))
        .toList();
    emit(state.copyWith(searchedProducts: products));
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
      // TODO: Get real user ID from AuthBloc
      await _productsServices.adjustStock(event.product, event.newStock, event.reason, 'admin_user_id');
      final products = await _productsServices.getProducts();
      emit(SuccessProductsState());
      emit(state.copyWith(products: products));
    } catch (e) {
      emit(FailureProductsState(e.toString()));
    }
  }
}
