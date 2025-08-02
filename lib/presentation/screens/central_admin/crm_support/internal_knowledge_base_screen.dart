import 'package:dukascango/domain/models/article.dart';
import 'package:dukascango/domain/services/article_service.dart';
import 'package:dukascango/presentation/screens/central_admin/crm_support/article_details_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/crm_support/create_article_screen.dart';
import 'package:flutter/material.dart';

class InternalKnowledgeBaseScreen extends StatefulWidget {
  @override
  _InternalKnowledgeBaseScreenState createState() =>
      _InternalKnowledgeBaseScreenState();
}

class _InternalKnowledgeBaseScreenState
    extends State<InternalKnowledgeBaseScreen> {
  late Future<List<Article>> _articles;

  @override
  void initState() {
    super.initState();
    _articles = ArticleService().getArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internal Knowledge Base'),
      ),
      body: FutureBuilder<List<Article>>(
        future: _articles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No articles found.'));
          } else {
            final articles = snapshot.data!;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ListTile(
                  title: Text(article.title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ArticleDetailsScreen(article: article),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateArticleScreen(),
            ),
          ).then((_) {
            // Refresh the list when coming back
            setState(() {
              _articles = ArticleService().getArticles();
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
