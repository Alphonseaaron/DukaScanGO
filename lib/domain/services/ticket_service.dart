import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/ticket.dart';

class TicketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTicket(Ticket ticket) async {
    await _firestore.collection('tickets').add(ticket.toMap());
  }

  Future<List<Ticket>> getTickets() async {
    final QuerySnapshot snapshot = await _firestore.collection('tickets').get();
    return snapshot.docs
        .map((doc) => Ticket.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> updateTicketStatus(String id, String status) async {
    await _firestore.collection('tickets').doc(id).update({'status': status});
  }
}
