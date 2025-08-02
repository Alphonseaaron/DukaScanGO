import 'package:dukascango/domain/models/featured_store.dart';
import 'package:dukascango/domain/models/user.dart';

class FeaturedStoreWithDetails {
  final FeaturedStore featuredStore;
  final User store;

  FeaturedStoreWithDetails({
    required this.featuredStore,
    required this.store,
  });
}
