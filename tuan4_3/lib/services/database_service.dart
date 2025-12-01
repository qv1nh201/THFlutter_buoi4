// file: lib/services/database_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Thêm import này
import '../models/book.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Thêm instance Auth

  Stream<List<Book>> getBooks() {
    return _db.collection('books').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Book.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // --- Thêm hàm Mượn sách dưới đây ---
  Future<void> borrowBook(String bookId, String title, String imageUrl) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Người dùng chưa đăng nhập");

    final bookRef = _db.collection('books').doc(bookId);
    final loanRef = _db.collection('loans').doc();

    await _db.runTransaction((transaction) async {
      final bookSnapshot = await transaction.get(bookRef);
      if (!bookSnapshot.exists) throw Exception("Sách không tồn tại!");
      if (bookSnapshot.data()!['isAvailable'] == false) throw Exception("Sách đã bị mượn!");

      transaction.update(bookRef, {'isAvailable': false});

      // Lưu thêm title và imageUrl vào phiếu mượn để dễ hiển thị
      transaction.set(loanRef, {
        'bookId': bookId,
        'title': title,           // Mới thêm
        'imageUrl': imageUrl,     // Mới thêm
        'userId': user.uid,
        'userEmail': user.email,
        'borrowDate': DateTime.now().toIso8601String(),
        'returnDate': null,
      });
    });
  }

  // 2. Thêm hàm lấy danh sách mượn của tôi
  Stream<QuerySnapshot> getMyLoans() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _db
        .collection('loans')
        .where('userId', isEqualTo: user.uid) // Chỉ lấy của user hiện tại
        .orderBy('borrowDate', descending: true) // Sắp xếp mới nhất lên đầu
        .snapshots();
  }


}