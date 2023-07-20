import 'package:school/models/Class.dart';
import 'package:school/models/ScoreType.dart';
import 'package:school/models/Student.dart';
import 'package:school/models/Subject.dart';

class Score {
  late Student studentId;
  late Subject subjectId;
  late ScoreType scoreTypeId;
  late Class classId;
  late int semester;
  late double score;

  Score({
    required this.studentId,
    required this.subjectId,
    required this.scoreTypeId,
    required this.classId,
    required this.semester,
    required this.score,
  });

  Score.fromMap(Map<String, dynamic> map) {
    studentId = Student.fromMap(map['student']);
    subjectId = Subject.fromMap(map['subject']);
    scoreTypeId = ScoreType.fromMap(map['scoreType']);
    classId = Class.fromMap(map['classes']);
    semester = map['semester'];
    score = map['score'];
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'subjectId': subjectId,
      'scoreTypeId': scoreTypeId,
      'classId': classId,
      'semester': semester,
      'score': score,
    };
  }
}


// Future<void> getData() async {
//   final studentId = localStorage.getItem("id");

//   // Gửi yêu cầu lấy thông tin lớp học
//   final responseClasses = await http.get(Uri.parse('/api/student/$studentId/classes'));
//   if (responseClasses.statusCode == 200) {
//     List<dynamic> classesJson = jsonDecode(responseClasses.body);
//     List<Classes> classes = classesJson.map((json) => Classes.fromJson(json)).toList();
//     // Lưu thông tin lớp học vào biến classes
//     // Do something with classes...
//   } else {
//     throw Exception('Lỗi khi lấy thông tin lớp học: ${responseClasses.statusCode}');
//   }

//   // Gửi yêu cầu lấy thông tin loại điểm
//   final scoreTypeResponse = await http.get(Uri.parse('/api/score-types'));
//   if (scoreTypeResponse.statusCode == 200) {
//     List<dynamic> scoreTypesJson = jsonDecode(scoreTypeResponse.body);
//     List<ScoreType> scoreTypes = scoreTypesJson.map((json) => ScoreType.fromJson(json)).toList();
//     // Lưu thông tin loại điểm vào biến scoreTypes
//     // Do something with scoreTypes...
//   } else {
//     throw Exception('Lỗi khi lấy thông tin loại điểm: ${scoreTypeResponse.statusCode}');
//   }

//   // Gửi yêu cầu lấy thông tin môn học
//   final subjectResponse = await http.get(Uri.parse('/api/subjects'));
//   if (subjectResponse.statusCode == 200) {
//     List<dynamic> subjectsJson = jsonDecode(subjectResponse.body);
//     List<Subject> subjects = subjectsJson.map((json) => Subject.fromJson(json)).toList();
//     // Lưu thông tin môn học vào biến subjects
//     // Do something with subjects...
//   } else {
//     throw Exception('Lỗi khi lấy thông tin môn học: ${subjectResponse.statusCode}');
//   }

//   // Gửi yêu cầu lấy thông tin điểm số
//   final classId = selectedClass; // Giả sử selectedClass đã được định nghĩa trước đó
//   final semester = yourSemester; // Giả sử yourSemester đã được định nghĩa trước đó
//   final scoreResponse = await http.get(Uri.parse('/api/scores/semester?classId=$classId&semester=$semester&studentId=$studentId'));
//   if (scoreResponse.statusCode == 200) {
//     List<dynamic> scoresJson = jsonDecode(scoreResponse.body);
//     List<Score> scores = scoresJson.map((json) => Score.fromJson(json)).toList();
//     // Lưu thông tin điểm số vào biến scores
//     // Do something with scores...
//   } else {
//     throw Exception('Lỗi khi lấy thông tin điểm số: ${scoreResponse.statusCode}');
//   }
// }

