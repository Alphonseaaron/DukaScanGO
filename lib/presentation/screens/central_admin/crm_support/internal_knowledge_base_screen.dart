import 'package:dukascango/presentation/screens/central_admin/crm_support/article_details_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/crm_support/create_article_screen.dart';
import 'package:flutter/material.dart';

class InternalKnowledgeBaseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Fetch real data
    final articles = [
      {'id': '1', 'title': 'How to reset your password'},
      {'id': '2', 'title': 'How to track your order'},
      {'id': '3', 'title': 'How to contact support'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Internal Knowledge Base'),
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return ListTile(
            title: Text(article['title']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleDetailsScreen(article: article),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateArticleScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
