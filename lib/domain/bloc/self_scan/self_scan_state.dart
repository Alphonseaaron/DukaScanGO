part of 'self_scan_bloc.dart';

@immutable
class SelfScanState {
  final String? storeId;
  final bool isSessionActive;
  final List<ProductCart> cart;
  final double total;
  final Product? currentProduct;
  final bool isProductFound;
  final bool showUpsellBanner;
  final List<Product> suggestions;

  const SelfScanState({
    this.storeId,
    this.isSessionActive = false,
    this.cart = const [],
    this.total = 0.0,
    this.currentProduct,
    this.isProductFound = true,
    this.showUpsellBanner = false,
    this.suggestions = const [],
  });

  SelfScanState copyWith({
    String? storeId,
    bool? isSessionActive,
    List<ProductCart>? cart,
    double? total,
    Product? currentProduct,
    bool? isProductFound,
    bool? showUpsellBanner,
    List<Product>? suggestions,
  }) =>
      SelfScanState(
        storeId: storeId ?? this.storeId,
        isSessionActive: isSessionActive ?? this.isSessionActive,
        cart: cart ?? this.cart,
        total: total ?? this.total,
        currentProduct: currentProduct ?? this.currentProduct,
        isProductFound: isProductFound ?? this.isProductFound,
        showUpsellBanner: showUpsellBanner ?? this.showUpsellBanner,
        suggestions: suggestions ?? this.suggestions,
      );
}
