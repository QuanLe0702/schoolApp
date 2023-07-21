import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:school/models/Document.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:school/screens/Document_screen/ExcelScreen.dart';

import 'WordScreen.dart';

class DocumentScreen extends StatefulWidget {
  static String routeName = 'DocumentScreen';
  const DocumentScreen({Key? key}) : super(key: key);

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  List<Document> documentList = [];
  List<Document> filteredDocumentList = [];
  TextEditingController searchController = TextEditingController();
  String? token;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    token = await storage.read(key: 'token');
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8080/api/documents'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      final List<dynamic> jsonData =
          jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        documentList = jsonData.map((item) => Document.fromMap(item)).toList();
        filteredDocumentList = documentList;
        _sortDocumentsByUpdatedAt();
      });
    } else {
      throw Exception('Failed');
    }
  }

  void filterDocuments(String keyword) {
    setState(() {
      filteredDocumentList = documentList
          .where((document) =>
              document.title.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  void _sortDocumentsByUpdatedAt() {
    filteredDocumentList.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<void> downloadDocument(String url, String fileName) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(response.bodyBytes);

      if (fileName.toLowerCase().endsWith(".pdf")) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFScreen(pdfPath: file.path),
          ),
        );
      } else if (fileName.toLowerCase().endsWith(".xlsx")) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExcelScreen(excelPath: file.path),
          ),
        );

        // } else if (fileName.toLowerCase().endsWith(".doc") ||
        //     fileName.toLowerCase().endsWith(".docx")) {
        //   // Xử lý tệp Word (DOC/DOCX)
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => WordScreen(wordPath: file.path),
        //     ),
        //   );
      } else {
        print('Tệp không được hỗ trợ!');
      }
      print('Tải xuống tệp $fileName thành công!');
    } else {
      print('Lỗi khi tải xuống tệp!');
    }
  }

  Widget getFileIcon(String fileName) {
    if (fileName.endsWith(".doc") || fileName.endsWith(".docx")) {
      return Image.asset(
        'assets/images/word_icon.png',
        width: 70,
      );
    } else if (fileName.endsWith(".pdf")) {
      return Image.asset(
        'assets/images/pdf_icon.png',
        width: 70,
      );
    } else if (fileName.endsWith(".xlsx")) {
      return Image.asset(
        'assets/images/excel.png',
        width: 70,
      );
    } else {
      return Container();
    }
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
          title: const Text('Tài liệu của tôi'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 45.0,
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    filterDocuments(value);
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
                itemCount: filteredDocumentList.length,
                itemBuilder: (context, index) {
                  final document = filteredDocumentList[index];
                  return GestureDetector(
                    onTap: () {},
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
                                child: getFileIcon(document.fileName),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 40,
                                      child: Text(
                                        document.title,
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
                                        document.description,
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
                                              .format(document.updatedAt),
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
                              IconButton(
                                onPressed: () {
                                  downloadDocument(
                                      'http://10.0.2.2:8080/api/documents/${document.id}/download',
                                      document.fileName);
                                },
                                icon: Icon(Icons.download),
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
    );
  }
}

class PDFScreen extends StatelessWidget {
  final String pdfPath;

  const PDFScreen({Key? key, required this.pdfPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nội dung'),
      ),
      body: PDFView(
        filePath: pdfPath,
      ),
    );
  }
}
