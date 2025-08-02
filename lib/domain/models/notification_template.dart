class NotificationTemplate {
  final String? id;
  final String name;
  final String subject;
  final String body;

  NotificationTemplate({
    this.id,
    required this.name,
    required this.subject,
    required this.body,
  });

  factory NotificationTemplate.fromMap(Map<String, dynamic> map, String id) {
    return NotificationTemplate(
      id: id,
      name: map['name'],
      subject: map['subject'],
      body: map['body'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'subject': subject,
      'body': body,
    };
  }
}
