import 'package:flutter/material.dart';
import '../models/schedule_model.dart';
import '../services/firestore_service.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch Học Hôm Nay"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // Sử dụng StreamBuilder để lắng nghe dữ liệu từ Firestore
        child: StreamBuilder<List<ScheduleModel>>(
          stream: FirestoreService().getSchedules(),
          builder: (context, snapshot) {
            // Trường hợp 1: Đang tải dữ liệu
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Trường hợp 2: Có lỗi xảy ra
            if (snapshot.hasError) {
              return Center(child: Text("Lỗi: ${snapshot.error}"));
            }

            // Trường hợp 3: Không có dữ liệu
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Chưa có lịch học nào."));
            }

            // Trường hợp 4: Có dữ liệu -> Hiển thị danh sách
            final schedules = snapshot.data!;

            return ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final item = schedules[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        item.subject.isNotEmpty ? item.subject[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      item.subject,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(item.time),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text("Phòng: ${item.room}"),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text("GV: ${item.teacher}"),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}