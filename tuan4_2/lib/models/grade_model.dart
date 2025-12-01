class GradeModel {
  final String id;
  final String subject;
  final double midtermScore; // Điểm giữa kỳ
  final double finalScore;   // Điểm cuối kỳ

  GradeModel({
    required this.id,
    required this.subject,
    required this.midtermScore,
    required this.finalScore,
  });

  factory GradeModel.fromMap(Map<String, dynamic> data, String documentId) {
    return GradeModel(
      id: documentId,
      subject: data['subject'] ?? '',
      // Chuyển đổi an toàn sang double
      midtermScore: (data['midtermScore'] ?? 0).toDouble(),
      finalScore: (data['finalScore'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'midtermScore': midtermScore,
      'finalScore': finalScore,
    };
  }
}