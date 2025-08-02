class Ticket {
  final String? id;
  final String userId;
  final String subject;
  final String description;
  final String status; // 'open', 'closed'
  final DateTime dateCreated;

  Ticket({
    this.id,
    required this.userId,
    required this.subject,
    required this.description,
    required this.status,
    required this.dateCreated,
  });

  factory Ticket.fromMap(Map<String, dynamic> map, String id) {
    return Ticket(
      id: id,
      userId: map['userId'],
      subject: map['subject'],
      description: map['description'],
      status: map['status'],
      dateCreated: map['dateCreated'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'subject': subject,
      'description': description,
      'status': status,
      'dateCreated': dateCreated,
    };
  }
}
