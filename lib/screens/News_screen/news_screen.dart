import 'package:flutter/material.dart';

import '../../components/menu_bottom.dart';

class News {
  final String title;
  final String content;

  News({required this.title, required this.content});
}

class NewsScreen extends StatelessWidget {
  NewsScreen({Key? key}) : super(key: key);

  static String routeName = 'NewsScreen';

  final List<News> newsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin tức'),
      ),
      bottomNavigationBar: const MenuBottom(),
      body: ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          final news = newsList[index];
          return ListTile(
            title: Text(news.title),
            subtitle: Text(news.content),
            onTap: () {
              // Handle tapping on a news item
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailScreen(news: news),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  final News news;

  const NewsDetailScreen({required this.news, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(news.content),
      ),
    );
  }
}
