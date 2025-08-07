import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dukascango/domain/models/product.dart';
import 'package:dukascango/domain/models/stock_adjustment.dart';
import 'package:image_picker/image_picker.dart';

class ProductsServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addProduct(Product product, List<XFile> images) async {
    final List<String> imageUrls = await uploadImages(images);
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

  Future<void> updateProductStatus(String id, String status) async {
    await _firestore.collection('products').doc(id).update({'status': status});
  }

  Future<Product?> getProductByBarcode(String barcode) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('products')
        .where('barcode', isEqualTo: barcode)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
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

  Future<List<Product>> getLowStockItems() async {
    final QuerySnapshot snapshot = await _firestore.collection('products').get();
    final products = snapshot.docs
        .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    return products.where((p) => p.stockQuantity != null && p.lowStockThreshold != null && p.stockQuantity! <= p.lowStockThreshold!).toList();
  }

  Future<Map<String, dynamic>> bulkUpdateProducts(List<Product> products) async {
    int successCount = 0;
    int failureCount = 0;
    List<String> errors = [];

    for (int i = 0; i < products.length; i++) {
      final product = products[i];
      try {
        if (product.barcode == null || product.barcode!.isEmpty) {
          throw Exception('Barcode is required for row ${i + 2}');
        }
        final existingProduct = await getProductByBarcode(product.barcode!);
        if (existingProduct != null) {
          await updateProduct(product.copyWith(id: existingProduct.id));
        } else {
          await addProduct(product, []);
        }
        successCount++;
      } catch (e) {
        failureCount++;
        errors.add('Row ${i + 2}: ${e.toString()}');
      }
    }
    return {
      'successCount': successCount,
      'failureCount': failureCount,
      'errors': errors,
    };
  }

  Future<void> adjustStock(Product product, int newStock, String reason, String userId) async {
    final writeBatch = _firestore.batch();

    final productRef = _firestore.collection('products').doc(product.id);
    writeBatch.update(productRef, {'stockQuantity': newStock});

    final adjustmentRef = _firestore.collection('stock_adjustments').doc();
    final adjustment = StockAdjustment(
      productId: product.id!,
      oldQuantity: product.stockQuantity ?? 0,
      newQuantity: newStock,
      reason: reason,
      date: DateTime.now(),
      userId: userId,
    );
    writeBatch.set(adjustmentRef, adjustment.toMap());

    await writeBatch.commit();
  }

  Future<List<Product>> getProductsByCategory(String categoryId) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('products')
        .where('category', isEqualTo: categoryId)
        .get();
    return snapshot.docs
        .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}

final productServices = ProductsServices();
