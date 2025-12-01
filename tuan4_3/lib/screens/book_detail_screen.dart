// file: lib/screens/book_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh bìa sách
            Center(
              child: Container(
                height: 200,
                width: 150,
                color: Colors.blue[100],
                // Logic hiển thị ảnh tương tự màn hình danh sách
                child: Builder(
                  builder: (context) {
                    if (book.imageUrl.isEmpty) {
                      return const Icon(Icons.book, size: 100, color: Colors.blue);
                    }
                    if (book.imageUrl.startsWith('assets/')) {
                      return Image.asset(
                        book.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 50, color: Colors.red),
                            Text("Lỗi ảnh", style: TextStyle(color: Colors.red, fontSize: 10)),
                          ],
                        ),
                      );
                    }
                    return Image.network(
                      book.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50, color: Colors.red),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tên sách và Tác giả
            Text(book.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Tác giả: ${book.author}', style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 10),

            // Trạng thái sách
            Row(
              children: [
                const Text('Trạng thái: ', style: TextStyle(fontSize: 16)),
                Text(
                  book.isAvailable ? 'Còn sách' : 'Hết sách',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: book.isAvailable ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Mô tả
            const Text('Mô tả:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(book.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 30),

            // Nút Mượn sách
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: book.isAvailable
                    ? () async {
                  try {
                    // Gọi hàm mượn sách từ Provider
                    await Provider.of<BookProvider>(context, listen: false)
                        .borrowBook(book);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mượn sách thành công!')),
                      );
                      Navigator.pop(context); // Quay lại màn hình trước
                    }
                  } catch (e) {
                    // Hiển thị lỗi nếu có vấn đề xảy ra
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi: ${e.toString()}')),
                      );
                    }
                  }
                }
                    : null, // Vô hiệu hóa nút nếu hết sách
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: book.isAvailable ? Colors.blue : Colors.grey,
                  foregroundColor: Colors.white, // Màu chữ trắng
                ),
                child: Text(
                  book.isAvailable ? 'Mượn Sách' : 'Đã Hết Sách',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}