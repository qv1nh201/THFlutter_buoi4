// file: lib/providers/book_provider.dart
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/database_service.dart';

class BookProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  // Getter lấy stream sách từ Service
  Stream<List<Book>> get booksStream => _databaseService.getBooks();

  // Hàm xử lý mượn sách (cập nhật theo Phần 6)
  Future<void> borrowBook(Book book) async {
    try {
      // Truyền id, title, imageUrl xuống service
      await _databaseService.borrowBook(book.id, book.title, book.imageUrl);
      // Không cần notifyListeners() vì StreamBuilder tự động cập nhật
    } catch (e) {
      rethrow; // Ném lỗi ra để UI xử lý
    }
  }
}