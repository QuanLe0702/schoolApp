import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:school/models/Class.dart';
import 'package:school/models/ScoreType.dart';
import 'package:school/models/Subject.dart';
import 'dart:convert';

class ScoreView extends StatefulWidget {
  static String routeName = 'ScoreView';
  const ScoreView({Key? key}) : super(key: key);

  @override
  _ScoreViewState createState() => _ScoreViewState();
}

class _ScoreViewState extends State<ScoreView> {
  List<Map<String, dynamic>> scoreData = [];
  List<ScoreType> scoreTypes = [];
  List<Subject> subjects = [];
  int semester = 1;
  List<Class> classes = [];
  int selectedClass = 0;
  Map<int, double?> averageScores = {};
  String? token;
  String? studentId;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    token = await storage.read(key: 'token');
    studentId = await storage.read(key: 'id');
    final responseClasses = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/student/$studentId/classes'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    final responseScoreTypes = await http
        .get(Uri.parse('http://10.0.2.2:8080/api/score-types'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    final responseSubjects = await http
        .get(Uri.parse('http://10.0.2.2:8080/api/subjects'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    setState(() {
      classes = (jsonDecode(responseClasses.body) as List<dynamic>)
          .map((classData) => Class.fromMap(classData))
          .toList();
      scoreTypes = (jsonDecode(responseScoreTypes.body) as List<dynamic>)
          .map((scoreTypeData) => ScoreType.fromMap(scoreTypeData))
          .toList();
      subjects =
          (jsonDecode(utf8.decode(responseSubjects.bodyBytes)) as List<dynamic>)
              .map((subjectData) => Subject.fromMap(subjectData))
              .where((subject) => !subject.name.startsWith('SHDC'))
              .toList();

      if (classes.isNotEmpty) {
        selectedClass = classes[0].id!;
      }
    });

    await fetchScoreData();
  }

  Future<void> fetchScoreData() async {
    final responseScore = await http.get(
        Uri.parse(
            'http://10.0.2.2:8080/api/scores/semester?classId=$selectedClass&semester=$semester&studentId=$studentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    final fetchedScoreData = jsonDecode(utf8.decode(responseScore.bodyBytes));

    setState(() {
      scoreData = subjects.map((subject) {
        final scoreRow = {
          'subjectId': subject.id,
          'subjectName': subject.name,
        };

        scoreTypes.forEach((scoreType) {
          final findScore = fetchedScoreData.firstWhere(
              (score) =>
                  score['subject']['id'] == subject.id &&
                  score['scoreType']['id'] == scoreType.id,
              orElse: () => null);

          if (findScore != null) {
            scoreRow[scoreType.id.toString()] = findScore['score'];
          } else {
            scoreRow[scoreType.id.toString()] = "-";
          }
        });

        return scoreRow;
      }).toList();

      for (var subject in subjects) {
        double sum = 0;
        double totalCoefficient = 0;
        int numScoreTypes = 0;

        scoreTypes.forEach((scoreType) {
          final findScore = fetchedScoreData.firstWhere(
              (score) =>
                  score['subject']['id'] == subject.id &&
                  score['scoreType']['id'] == scoreType.id,
              orElse: () => null);

          if (findScore != null) {
            sum += findScore['score'] * scoreType.coefficient;
            totalCoefficient += scoreType.coefficient;
            numScoreTypes++;
          }
        });

        final average = (totalCoefficient > 0 && numScoreTypes >= 6)
            ? (sum / totalCoefficient)
            : null;

        averageScores[subject.id!] = average;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xem điểm'),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<int>(
                      value: semester,
                      onChanged: (newValue) {
                        setState(() {
                          semester = newValue!;
                        });
                        fetchScoreData();
                      },
                      items: [1, 2].map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            'Học kỳ $value',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButton<int>(
                      value: selectedClass,
                      onChanged: (newValue) {
                        setState(() {
                          selectedClass = newValue!;
                        });
                        fetchScoreData();
                      },
                      items: classes.map<DropdownMenuItem<int>>((classItem) {
                        return DropdownMenuItem<int>(
                          value: classItem.id!,
                          child: Text(
                            'LH${classItem.id}_${classItem.name}',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Vị trí "-" là thông tin chưa được công bố. Chi tiết liên hệ nhà trường',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Table(
                    columnWidths: {
                      0: const FlexColumnWidth(2),
                      for (var i = 0; i < scoreTypes.length; i++)
                        i + 1: const FlexColumnWidth(1),
                      scoreTypes.length + 1: const FlexColumnWidth(1),
                    },
                    border: TableBorder.all(),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                        ),
                        children: [
                          const TableCell(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text(
                                  'MÔN HỌC',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          for (var scoreType in scoreTypes)
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    scoreType.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          const TableCell(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text(
                                  'Đ TB',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (var scoreRow in scoreData)
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(scoreRow['subjectName'],
                                      style: const TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 13)),
                                ),
                              ),
                            ),
                            for (var scoreType in scoreTypes)
                              TableCell(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      scoreRow[scoreType.id.toString()]
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    scoreRow['average'] != null
                                        ? scoreRow['average']!
                                            .toStringAsFixed(2)
                                        : '-',
                                    style: TextStyle(
                                      color: scoreRow['average'] != null
                                          ? Colors.black
                                          : Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
