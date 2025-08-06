import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/invitation.dart';

class InvitationServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createInvitation(Invitation invitation) async {
    await _firestore.collection('invitations').add(invitation.toMap());
  }

  Future<List<Invitation>> getInvitationsForUser(String userId) async {
    final snapshot = await _firestore
        .collection('invitations')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) => Invitation.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> updateInvitationStatus(String id, String status) async {
    await _firestore
        .collection('invitations')
        .doc(id)
        .update({'status': status});
  }
}
