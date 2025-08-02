import 'package:dukascango/domain/models/article.dart';
import 'package:flutter/material.dart';

class ArticleDetailsScreen extends StatelessWidget {
  final Article article;

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
            Text('ID: ${article.id}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Title: ${article.title}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Content: ${article.content}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
