class Article {
  final String? id;
  final String title;
  final String content;
  final String category;
  final DateTime dateCreated;

  Article({
    this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.dateCreated,
  });

  factory Article.fromMap(Map<String, dynamic> map, String id) {
    return Article(
      id: id,
      title: map['title'],
      content: map['content'],
      category: map['category'],
      dateCreated: map['dateCreated'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'category': category,
      'dateCreated': dateCreated,
    };
  }
}
