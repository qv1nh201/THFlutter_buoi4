// file: lib/models/book.dart
class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String imageUrl;
  final bool isAvailable; // Trạng thái: true = còn sách, false = đã mượn

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.isAvailable,
  });

  // Hàm chuyển đổi từ JSON/Map (dùng khi lấy từ Firebase sau này)
  factory Book.fromMap(Map<String, dynamic> data, String documentId) {
    return Book(
      id: documentId,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      isAvailable: data['isAvailable'] ?? true,
    );
  }

  // Hàm chuyển đổi sang Map (dùng khi đẩy lên Firebase)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
    };
  }
}