// file: lib/screens/history_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService dbService = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch Sử Mượn'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: dbService.getMyLoans(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Lỗi tải dữ liệu'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text('Bạn chưa mượn cuốn sách nào.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              // Xử lý ngày tháng
              String borrowDate = data['borrowDate'] ?? '';
              if (borrowDate.length > 10) borrowDate = borrowDate.substring(0, 10);

              // Lấy đường dẫn ảnh
              String imageUrl = data['imageUrl'] ?? '';

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    // Logic hiển thị ảnh thông minh (Assets hoặc Network)
                    child: Builder(
                      builder: (context) {
                        if (imageUrl.isEmpty) {
                          return const Icon(Icons.book, color: Colors.blue);
                        }
                        // Nếu là ảnh trong máy
                        if (imageUrl.startsWith('assets/')) {
                          return Image.asset(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.red),
                          );
                        }
                        // Nếu là ảnh mạng
                        return Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.red),
                        );
                      },
                    ),
                  ),
                  title: Text(data['title'] ?? 'Sách không tên'),
                  subtitle: Text('Ngày mượn: $borrowDate'),
                  trailing: const Text(
                    'Đang mượn',
                    style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}