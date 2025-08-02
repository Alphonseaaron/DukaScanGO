import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/notification_template.dart';

class NotificationTemplateService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addNotificationTemplate(NotificationTemplate template) async {
    await _firestore.collection('notification_templates').add(template.toMap());
  }

  Future<List<NotificationTemplate>> getNotificationTemplates() async {
    final QuerySnapshot snapshot =
        await _firestore.collection('notification_templates').get();
    return snapshot.docs
        .map((doc) => NotificationTemplate.fromMap(
            doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> updateNotificationTemplate(NotificationTemplate template) async {
    await _firestore
        .collection('notification_templates')
        .doc(template.id)
        .update(template.toMap());
  }
}
