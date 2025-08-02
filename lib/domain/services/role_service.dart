import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/role.dart';

class RoleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addRole(Role role) async {
    await _firestore.collection('roles').add(role.toMap());
  }

  Future<List<Role>> getRoles() async {
    final QuerySnapshot snapshot = await _firestore.collection('roles').get();
    return snapshot.docs
        .map((doc) => Role.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> updateRole(Role role) async {
    await _firestore.collection('roles').doc(role.id).update(role.toMap());
  }
}
