import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/article.dart';

class ArticleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addArticle(Article article) async {
    await _firestore.collection('articles').add(article.toMap());
  }

  Future<List<Article>> getArticles() async {
    final QuerySnapshot snapshot = await _firestore.collection('articles').get();
    return snapshot.docs
        .map((doc) => Article.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> updateArticle(Article article) async {
    await _firestore
        .collection('articles')
        .doc(article.id)
        .update(article.toMap());
  }

  Future<void> deleteArticle(String id) async {
    await _firestore.collection('articles').doc(id).delete();
  }
}
