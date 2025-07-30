import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:restaurant/domain/models/user.dart';
import 'package:image_picker/image_picker.dart';

class UserServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addUser(User user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<User?> getUserById(String uid) async {
    final DocumentSnapshot doc =
        await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return User.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUser(User user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toMap());
  }

  Future<String> uploadImage(XFile image) async {
    final File file = File(image.path);
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference ref = _storage.ref().child('users').child(fileName);
    final UploadTask uploadTask = ref.putFile(file);
    final TaskSnapshot snapshot = await uploadTask;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> updateUserProfileImage(String uid, String imageUrl) async {
    await _firestore.collection('users').doc(uid).update({'image': imageUrl});
  }
}
