import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/performance_bonus.dart';

class PerformanceBonusService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPerformanceBonus(PerformanceBonus bonus) async {
    await _firestore.collection('performance_bonuses').add(bonus.toMap());
  }

  Future<List<PerformanceBonus>> getPerformanceBonuses() async {
    final QuerySnapshot snapshot =
        await _firestore.collection('performance_bonuses').get();
    return snapshot.docs
        .map((doc) =>
            PerformanceBonus.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
