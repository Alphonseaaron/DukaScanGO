import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/brand.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class BrandService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addBrand(Brand brand, XFile? image) async {
    String? imageUrl;
    if (image != null) {
      imageUrl = await uploadImage(image);
    }
    final brandWithLogo = brand.copyWith(logoUrl: imageUrl);
    await _firestore.collection('brands').add(brandWithLogo.toMap());
  }

  Future<List<Brand>> getBrands() async {
    final QuerySnapshot snapshot = await _firestore.collection('brands').get();
    return snapshot.docs
        .map((doc) => Brand.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<Brand?> getBrandById(String id) async {
    final DocumentSnapshot doc =
        await _firestore.collection('brands').doc(id).get();
    if (doc.exists) {
      return Brand.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<void> updateBrand(Brand brand, XFile? image) async {
    String? imageUrl;
    if (image != null) {
      imageUrl = await uploadImage(image);
    }
    final brandWithLogo = brand.copyWith(logoUrl: imageUrl ?? brand.logoUrl);
    await _firestore
        .collection('brands')
        .doc(brand.id)
        .update(brandWithLogo.toMap());
  }

  Future<void> deleteBrand(String id) async {
    await _firestore.collection('brands').doc(id).delete();
  }

  Future<String> uploadImage(XFile image) async {
    final File file = File(image.path);
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference ref = _storage.ref().child('brands').child(fileName);
    final UploadTask uploadTask = ref.putFile(file);
    final TaskSnapshot snapshot = await uploadTask;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
