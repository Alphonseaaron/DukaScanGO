import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/product_placement.dart';

class ProductPlacementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProductPlacement(ProductPlacement productPlacement) async {
    await _firestore
        .collection('product_placements')
        .add(productPlacement.toMap());
  }

  Future<List<ProductPlacement>> getProductPlacements() async {
    final QuerySnapshot snapshot =
        await _firestore.collection('product_placements').get();
    return snapshot.docs
        .map((doc) =>
            ProductPlacement.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<ProductPlacement?> getProductPlacementById(String id) async {
    final DocumentSnapshot doc =
        await _firestore.collection('product_placements').doc(id).get();
    if (doc.exists) {
      return ProductPlacement.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<void> updateProductPlacement(ProductPlacement productPlacement) async {
    await _firestore
        .collection('product_placements')
        .doc(productPlacement.id)
        .update(productPlacement.toMap());
  }

  Future<void> deleteProductPlacement(String id) async {
    await _firestore.collection('product_placements').doc(id).delete();
  }
}
