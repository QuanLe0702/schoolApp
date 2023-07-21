import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school/models/Class.dart';
import 'package:school/models/Schedule/DayOfWeek.dart';
import 'package:school/models/Schedule/Lesson.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScheduleView extends StatefulWidget {
  static String routeName = 'ScheduleView';
  const ScheduleView({Key? key}) : super(key: key);

  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  List<Map<String, dynamic>> scheduleData = [];
  List<DayOfWeek> dayOfWeekData = [];
  List<Class> classes = [];
  List<Lesson> tietData = [];
  int selectedClass = 0;
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

    // Lấy dữ liệu lớp học, ngày trong tuần và các dữ liệu khác cần thiết từ API
    final responseClasses = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/student/$studentId/classes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responseLessons = await http.get(
      Uri.parse("http://10.0.2.2:8080/api/lessons"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responseDayOfWeek = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/dayofweek'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Giả sử bạn có mô hình Class, DayOfWeek và các lớp mô hình khác như đã định nghĩa trong model.
    setState(() {
      classes =
          (jsonDecode(utf8.decode(responseClasses.bodyBytes)) as List<dynamic>)
              .map((classData) => Class.fromMap(classData))
              .toList();
      dayOfWeekData = (jsonDecode(utf8.decode(responseDayOfWeek.bodyBytes))
              as List<dynamic>)
          .map((dayOfWeekData) => DayOfWeek.fromMap(dayOfWeekData))
          .toList();
      tietData =
          (jsonDecode(utf8.decode(responseLessons.bodyBytes)) as List<dynamic>)
              .map((lessonData) => Lesson.fromMap(lessonData))
              .toList();

      if (classes.isNotEmpty) {
        selectedClass = classes[0].id!;
      }
    });

    await fetchScheduleData();
  }

  Future<void> fetchScheduleData() async {
    // Lấy dữ liệu thời khóa biểu cho lớp đã chọn và đổ vào danh sách scheduleData
    final responseSchedule = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/schedules/class/$selectedClass'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final fetchedScheduleData =
        jsonDecode(utf8.decode(responseSchedule.bodyBytes));

    setState(() {
      scheduleData = tietData.map((t) {
        final scheduleRow = {
          'lessonId': t.id,
          'lessonName': t.name,
          'startTime': t.startTime,
          'endTime': t.endTime,
        };

        dayOfWeekData.forEach((d) {
          final findSchedules = fetchedScheduleData.firstWhere(
              (s) =>
                  s['lesson']['id'] == t.id &&
                  s['dayOfWeek']['id'] == d.id &&
                  s['status'] == 'Active',
              orElse: () => null);

          if (findSchedules != null) {
            scheduleRow[d.id.toString()] = {
              'subjectId': findSchedules['subject']['id'].toString(),
              'subjectName': findSchedules['subject']['name'],
              'classId': findSchedules['classes']['id'],
              'className': findSchedules['classes']['name'],
              'teacherId': findSchedules['teacher']['id'],
              'teacherName': findSchedules['teacher']['name'],
              'startTime': findSchedules['startTime'],
              'endTime': findSchedules['endTime'],
            };
          } else {
            scheduleRow[d.id.toString()] = {
              'subjectId': '',
              'subjectName': '',
              'teacherId': '',
              'teacherName': '',
              'startTime': '',
              'endTime': '',
              'classId': '',
              'className': '',
            };
          }
        });

        return scheduleRow;
      }).toList();
    });
  }

  String formatTime(String timeString) {
    return timeString.substring(0, 5);
  }

  String getTimeFromDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    final time = TimeOfDay.fromDateTime(dateTime);
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thời Khóa Biểu'),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hiển thị dropdown để chọn lớp học
              DropdownButton<int>(
                value: selectedClass,
                onChanged: (newValue) {
                  setState(() {
                    selectedClass = newValue!;
                  });
                  fetchScheduleData();
                },
                items: classes.map<DropdownMenuItem<int>>((classItem) {
                  return DropdownMenuItem<int>(
                    value: classItem.id!,
                    child: Text(
                      'LH${classItem.id}_${classItem.name}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Hiển thị bảng thời khóa biểu
              Expanded(
                child: SingleChildScrollView(
                  child: Table(
                    columnWidths: {
                      0: const FlexColumnWidth(2),
                      for (var i = 0; i < dayOfWeekData.length; i++)
                        i + 1: const FlexColumnWidth(2),
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
                                  'Tiết',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          for (var dayOfWeek in dayOfWeekData)
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Text(
                                    dayOfWeek.name,
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
                        ],
                      ),
                      for (var scheduleRow in scheduleData)
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        scheduleRow['lessonName'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '(${formatTime(scheduleRow['startTime'])} - ${formatTime(scheduleRow['endTime'])})',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            for (var dayOfWeek in dayOfWeekData)
                              TableCell(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 6),
                                        if (scheduleRow[dayOfWeek.id.toString()]
                                                ['subjectName'] !=
                                            '')
                                          Column(
                                            children: [
                                              Text(
                                                scheduleRow[dayOfWeek.id
                                                    .toString()]['subjectName'],
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                scheduleRow[dayOfWeek.id
                                                    .toString()]['teacherName'],
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 9,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          )
                                        else
                                          Text(
                                            '-',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                      ],
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
