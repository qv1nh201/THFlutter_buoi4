class ScheduleModel {
  final String id;
  final String subject;
  final String time;
  final String room;
  final String teacher;

  ScheduleModel({
    required this.id,
    required this.subject,
    required this.time,
    required this.room,
    required this.teacher,
  });

  factory ScheduleModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ScheduleModel(
      id: documentId,
      subject: data['subject'] ?? '',
      time: data['time'] ?? '',
      room: data['room'] ?? '',
      teacher: data['teacher'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'time': time,
      'room': room,
      'teacher': teacher,
    };
  }
}