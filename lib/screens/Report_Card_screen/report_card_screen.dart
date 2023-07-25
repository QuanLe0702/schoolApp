import 'dart:convert';
import 'package:school/constants.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:school/models/ReportCard.dart';
import 'widget/report_card_detail.dart';

class ReportCardScreen extends StatefulWidget {
  static String routeName = 'ReportCardScreen';
  const ReportCardScreen({Key? key}) : super(key: key);

  @override
  State<ReportCardScreen> createState() => _ReportCardScreenState();
}

class _ReportCardScreenState extends State<ReportCardScreen> {
  List<ReportCard> reportCardList = [];
  List<ReportCard> filteredReportCardList = [];
  String? token;
  String? studentId;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  //fetch student data through api
  Future<void> fetchData() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    token = await storage.read(key: 'token');
    studentId = await storage.read(key: 'id');
    final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:8080/api/report_cards/search/studentId?id=$studentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    if (response.statusCode == 200) {
      final List<dynamic> jsonData =
          jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        reportCardList =
            jsonData.map((item) => ReportCard.fromMap(item)).toList();
        filteredReportCardList = reportCardList;
      });
    } else {
      throw Exception('Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hạnh kiểm'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: kOtherColor,
                borderRadius: kTopBorderRadius,
              ),
              child: ListView.builder(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  itemCount: filteredReportCardList.length,
                  itemBuilder: (context, index) {
                    final reportCard = filteredReportCardList[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: kDefaultPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(kDefaultPadding),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(kDefaultPadding),
                              color: kOtherColor,
                              boxShadow: const [
                                BoxShadow(
                                  color: kTextLightColor,
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                kHalfSizedBox,
                                Text(
                                  reportCard.violate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: kErrorBorderColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                kHalfSizedBox,
                                ReportCardDetailRow(
                                  title: 'Mô tả',
                                  statusValue: reportCard.description,
                                ),
                                kHalfSizedBox,
                                ReportCardDetailRow(
                                  title: 'Ngày',
                                  statusValue: DateFormat('yyyy-MM-dd HH:mm')
                                      .format(reportCard.date),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
