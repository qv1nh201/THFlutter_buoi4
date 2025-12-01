import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/schedule_model.dart';
import '../models/grade_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Lấy danh sách Lịch học (Schedules) dưới dạng Stream (thời gian thực)
  Stream<List<ScheduleModel>> getSchedules() {
    return _db.collection('schedules').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ScheduleModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Lấy danh sách Điểm số (Grades) của một học sinh cụ thể
  // Lưu ý: Ở giai đoạn này tạm thời lấy tất cả để test, sau này sẽ lọc theo userId
  Stream<List<GradeModel>> getGrades() {
    return _db.collection('grades').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return GradeModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Hàm tạo dữ liệu mẫu (Chỉ dùng để test)
  Future<void> createDummyData() async {
    // Tạo lịch học mẫu
    final scheduleRef = _db.collection('schedules');
    if ((await scheduleRef.get()).docs.isEmpty) {
      await scheduleRef.add({
        'subject': 'Lập trình Flutter',
        'time': '07:00 - 11:00',
        'room': 'Lab 1',
        'teacher': 'Thầy A'
      });
      await scheduleRef.add({
        'subject': 'Cơ sở dữ liệu',
        'time': '13:00 - 15:00',
        'room': 'A205',
        'teacher': 'Cô B'
      });
    }

    // Tạo điểm số mẫu
    final gradesRef = _db.collection('grades');
    if ((await gradesRef.get()).docs.isEmpty) {
      await gradesRef.add({
        'subject': 'Lập trình Flutter',
        'midtermScore': 8.5,
        'finalScore': 9.0,
      });
      await gradesRef.add({
        'subject': 'Toán cao cấp',
        'midtermScore': 7.0,
        'finalScore': 7.5,
      });
    }
  }
}