part of 'self_scan_bloc.dart';

@immutable
abstract class SelfScanEvent {}

class OnStoreScannedEvent extends SelfScanEvent {
  final String storeId;

  OnStoreScannedEvent(this.storeId);
}

class OnProductScannedEvent extends SelfScanEvent {
  final String barcode;
  OnProductScannedEvent(this.barcode);
}

class OnProductAddedToCartEvent extends SelfScanEvent {
  final ProductCart product;
  OnProductAddedToCartEvent(this.product);
}

class OnDismissUpsellBannerEvent extends SelfScanEvent {}

class OnGetSuggestionsEvent extends SelfScanEvent {
  final List<String> productIds;

  OnGetSuggestionsEvent(this.productIds);
}
