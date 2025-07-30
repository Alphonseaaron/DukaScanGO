import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:restaurant/domain/models/product.dart';
import 'package:image_picker/image_picker.dart';

class ProductsServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addProduct(Product product, List<XFile> images) async {
    final List<String> imageUrls = await _uploadImages(images);
    final productWithImages = product.copyWith(images: imageUrls);
    await _firestore
        .collection('products')
        .add(productWithImages.toMap());
  }

  Future<List<Product>> getProducts() async {
    final QuerySnapshot snapshot =
        await _firestore.collection('products').get();
    return snapshot.docs
        .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<Product?> getProductById(String id) async {
    final DocumentSnapshot doc =
        await _firestore.collection('products').doc(id).get();
    if (doc.exists) {
      return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<void> updateProduct(Product product) async {
    await _firestore
        .collection('products')
        .doc(product.id)
        .update(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _firestore.collection('products').doc(id).delete();
  }

  Future<List<String>> uploadImages(List<XFile> images) async {
    final List<String> imageUrls = [];
    for (final image in images) {
      final File file = File(image.path);
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference ref = _storage.ref().child('products').child(fileName);
      final UploadTask uploadTask = ref.putFile(file);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }
    return imageUrls;
  }
}
