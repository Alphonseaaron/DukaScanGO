import 'package:bloc/bloc.dart';
import 'package:dukascango/domain/services/suggestion_service.dart';
import 'package:meta/meta.dart';
import 'package:dukascango/domain/models/product.dart';
import 'package:dukascango/domain/models/product_cart.dart';
import 'package:dukascango/domain/services/products_services.dart';

part 'self_scan_event.dart';
part 'self_scan_state.dart';

class SelfScanBloc extends Bloc<SelfScanEvent, SelfScanState> {
  final ProductsServices _productsServices = ProductsServices();
  final SuggestionService _suggestionService = SuggestionService();

  SelfScanBloc() : super(const SelfScanState()) {
    on<OnStoreScannedEvent>(_onStoreScanned);
    on<OnProductScannedEvent>(_onProductScanned);
    on<OnProductAddedToCartEvent>(_onProductAddedToCart);
    on<OnDismissUpsellBannerEvent>(_onDismissUpsellBanner);
    on<OnGetSuggestionsEvent>(_onGetSuggestions);
  }

  Future<void> _onGetSuggestions(OnGetSuggestionsEvent event, Emitter<SelfScanState> emit) async {
    final suggestions = await _suggestionService.getProductSuggestions(event.productIds);
    emit(state.copyWith(suggestions: suggestions, showUpsellBanner: true));
  }

  Future<void> _onStoreScanned(OnStoreScannedEvent event, Emitter<SelfScanState> emit) async {
    emit(state.copyWith(storeId: event.storeId, isSessionActive: true));
  }

  Future<void> _onProductScanned(OnProductScannedEvent event, Emitter<SelfScanState> emit) async {
    final product = await _productsServices.getProductByBarcode(event.barcode);
    if (product != null) {
      emit(state.copyWith(currentProduct: product, isProductFound: true));
      final productCart = ProductCart(
        uidProduct: product.id!,
        imageProduct: product.images.isNotEmpty ? product.images.first : '',
        nameProduct: product.name,
        price: product.price,
        quantity: 1,
      );
      add(OnProductAddedToCartEvent(productCart));
      add(OnGetSuggestionsEvent(state.cart.map((p) => p.uidProduct).toList()));
    } else {
      emit(state.copyWith(isProductFound: false, showUpsellBanner: false));
    }
  }

  Future<void> _onDismissUpsellBanner(OnDismissUpsellBannerEvent event, Emitter<SelfScanState> emit) async {
    emit(state.copyWith(showUpsellBanner: false));
  }

  Future<void> _onProductAddedToCart(OnProductAddedToCartEvent event, Emitter<SelfScanState> emit) async {
    final List<ProductCart> updatedCart = List.from(state.cart);
    final existingProductIndex = updatedCart.indexWhere((p) => p.uidProduct == event.product.uidProduct);

    if (existingProductIndex != -1) {
      final existingProduct = updatedCart[existingProductIndex];
      updatedCart[existingProductIndex] = existingProduct.copyWith(quantity: existingProduct.quantity + 1);
    } else {
      updatedCart.add(event.product);
    }

    final double total = updatedCart.fold(0, (sum, item) => sum + (item.price * item.quantity));

    emit(state.copyWith(cart: updatedCart, total: total));
  }
}
