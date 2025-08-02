import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/page.dart';

class PageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPage(Page page) async {
    await _firestore.collection('pages').add(page.toMap());
  }

  Future<List<Page>> getPages() async {
    final QuerySnapshot snapshot = await _firestore.collection('pages').get();
    return snapshot.docs
        .map((doc) => Page.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> updatePage(Page page) async {
    await _firestore.collection('pages').doc(page.id).update(page.toMap());
  }
}
