import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/global_settings.dart';

class GlobalSettingsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _docId = 'global_settings'; // Use a fixed ID for global settings

  Future<GlobalSettings?> getGlobalSettings() async {
    final DocumentSnapshot doc =
        await _firestore.collection('settings').doc(_docId).get();
    if (doc.exists) {
      return GlobalSettings.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<void> updateGlobalSettings(GlobalSettings settings) async {
    await _firestore
        .collection('settings')
        .doc(_docId)
        .set(settings.toMap());
  }
}
