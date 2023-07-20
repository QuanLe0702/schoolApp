import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:school/components/menu_bottom.dart';
import 'package:school/models/News.dart';
import 'dart:convert';
import 'dart:typed_data';

class NewsListScreen extends StatefulWidget {
  static String routeName = 'NewsListScreen';

  const NewsListScreen({Key? key}) : super(key: key);

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  List<News> newsList = [];
  List<News> filteredNewsList = [];
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/news'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    if (response.statusCode == 200) {
      final List<dynamic> jsonData =
          jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        newsList = jsonData.map((item) => News.fromMap(item)).toList();
        filteredNewsList = newsList.where((news) => news.isActive).toList();
        _sortNewsByUpdatedAt();
      });
    } else {
      throw Exception('Failed to fetch news');
    }
  }

  void filterNews(String keyword) {
    setState(() {
      filteredNewsList = newsList
          .where((news) =>
              news.isActive &&
              news.title.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  void _sortNewsByUpdatedAt() {
    filteredNewsList.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      onVerticalDragDown: (_) {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tin tức của tôi'),
        ),
        bottomNavigationBar: const MenuBottom(),
        body: GestureDetector(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 45.0,
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      filterNews(value);
                    },
                    style: const TextStyle(
                      color: Color.fromARGB(255, 99, 99, 99),
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Tìm kiếm theo tiêu đề',
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredNewsList.length,
                  itemBuilder: (context, index) {
                    final news = filteredNewsList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetailsScreen(news: news),
                          ),
                        );
                      },
                      child: Container(
                        height: 150,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Image.asset(
                                    'assets/images/student_profile.jpeg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 40,
                                        child: Text(
                                          news.title.length > 50
                                              ? '${news.title.substring(0, 50)}...'
                                              : news.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color:
                                                Color.fromARGB(255, 7, 16, 142),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      SizedBox(
                                        height: 40,
                                        child: Text(
                                          news.content.length > 40
                                              ? '${news.content.substring(0, 40)}...'
                                              : news.content,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Color.fromARGB(255, 4, 0, 0),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2.0),
                                      Row(
                                        children: [
                                          const Icon(Icons.access_time,
                                              color: Colors.grey, size: 16.0),
                                          const SizedBox(width: 4.0),
                                          Text(
                                            DateFormat('yyyy-MM-dd HH:mm')
                                                .format(news.updatedAt),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsDetailsScreen extends StatelessWidget {
  final News news;
  const NewsDetailsScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết tin tức'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Color.fromARGB(255, 7, 16, 142),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.grey, size: 16.0),
                  const SizedBox(width: 4.0),
                  Text(
                    DateFormat('yyyy-MM-dd HH:mm').format(news.updatedAt),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Image.asset(
                'assets/images/student_profile.jpeg',
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16.0),
              Text(
                news.content,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Color.fromARGB(255, 4, 0, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
