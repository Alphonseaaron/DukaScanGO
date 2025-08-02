class Page {
  final String? id;
  final String title;
  final String content;

  Page({
    this.id,
    required this.title,
    required this.content,
  });

  factory Page.fromMap(Map<String, dynamic> map, String id) {
    return Page(
      id: id,
      title: map['title'],
      content: map['content'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
    };
  }
}
