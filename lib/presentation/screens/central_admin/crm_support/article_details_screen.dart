import 'package:flutter/material.dart';

class ArticleDetailsScreen extends StatelessWidget {
  final Map<String, String> article;

  const ArticleDetailsScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${article['id']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Title: ${article['title']}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
