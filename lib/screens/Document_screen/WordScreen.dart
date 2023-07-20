// import 'package:flutter/material.dart';
// import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

// class WordScreen extends StatefulWidget {
//   final String wordPath;

//   const WordScreen({Key? key, required this.wordPath}) : super(key: key);

//   @override
//   State<WordScreen> createState() => _WordScreenState();
// }

// class _WordScreenState extends State<WordScreen> {
//   PDFDocument? document;

//   @override
//   void initState() {
//     super.initState();
//     loadDocument();
//   }

//   Future<void> loadDocument() async {
//     final pdf = await PDFDocument.fromAsset(widget.wordPath);
//     setState(() {
//       document = pdf;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Nội dung Word'),
//       ),
//       body: document == null
//           ? const Center(child: CircularProgressIndicator())
//           : PDFViewer(document: document!),
//     );
//   }
// }
