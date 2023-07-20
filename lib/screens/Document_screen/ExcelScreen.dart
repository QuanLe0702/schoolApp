import 'dart:io';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';

class ExcelScreen extends StatefulWidget {
  final String excelPath;

  const ExcelScreen({Key? key, required this.excelPath}) : super(key: key);

  @override
  _ExcelScreenState createState() => _ExcelScreenState();
}

class _ExcelScreenState extends State<ExcelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excel Viewer'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await readAndShowExcel();
          },
          child: Text('Open Excel'),
        ),
      ),
    );
  }

  Future<void> readAndShowExcel() async {
    if (widget.excelPath.isNotEmpty) {
      final file = File(widget.excelPath);
      final bytes = await file.readAsBytes();
      final excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        print(table); // Tên của các bảng trong tệp Excel
        print(excel.tables[table]); // Nội dung của từng bảng
      }
      // Ở đây, bạn có thể làm gì đó với nội dung của tệp Excel, ví dụ: đọc dữ liệu và hiển thị lên màn hình
    }
  }
}
