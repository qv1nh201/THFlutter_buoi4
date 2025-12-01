class UserModel {
  final String id;
  final String email;
  final String role; // 'student', 'teacher', 'parent'

  UserModel({
    required this.id,
    required this.email,
    required this.role,
  });

  // Hàm chuyển từ JSON (Firestore) sang Object
  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      id: documentId,
      email: data['email'] ?? '',
      role: data['role'] ?? 'student',
    );
  }

  // Hàm chuyển từ Object sang JSON (để lưu lên Firestore)
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role,
    };
  }
}