import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/featured_store.dart';
import 'package:dukascango/domain/models/featured_store_with_details.dart';
import 'package:dukascango/domain/models/user.dart';
import 'package:dukascango/domain/services/user_services.dart';

class FeaturedStoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserServices _userServices = UserServices();

  Future<void> addFeaturedStore(FeaturedStore featuredStore) async {
    await _firestore.collection('featured_stores').add(featuredStore.toMap());
  }

  Future<List<FeaturedStore>> getFeaturedStores() async {
    final QuerySnapshot snapshot =
        await _firestore.collection('featured_stores').get();
    return snapshot.docs
        .map((doc) =>
            FeaturedStore.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<FeaturedStore?> getFeaturedStoreById(String id) async {
    final DocumentSnapshot doc =
        await _firestore.collection('featured_stores').doc(id).get();
    if (doc.exists) {
      return FeaturedStore.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<void> updateFeaturedStore(FeaturedStore featuredStore) async {
    await _firestore
        .collection('featured_stores')
        .doc(featuredStore.id)
        .update(featuredStore.toMap());
  }

  Future<void> deleteFeaturedStore(String id) async {
    await _firestore.collection('featured_stores').doc(id).delete();
  }

  Future<List<FeaturedStoreWithDetails>> getFeaturedStoresWithDetails() async {
    final featuredStores = await getFeaturedStores();
    final storesWithDetails = <FeaturedStoreWithDetails>[];
    for (final featuredStore in featuredStores) {
      final store = await _userServices.getUserById(featuredStore.storeId);
      if (store != null) {
        storesWithDetails.add(FeaturedStoreWithDetails(
          featuredStore: featuredStore,
          store: store,
        ));
      }
    }
    return storesWithDetails;
  }
}
