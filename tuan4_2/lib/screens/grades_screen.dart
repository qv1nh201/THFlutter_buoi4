import 'package:flutter/material.dart';
import '../models/grade_model.dart';
import '../services/firestore_service.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bảng Điểm Học Kỳ"),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<List<GradeModel>>(
        stream: FirestoreService().getGrades(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Chưa có bảng điểm."));
          }

          final grades = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Học Kỳ 1 - Năm học 2024-2025",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    child: DataTable(
                      columnSpacing: 20,
                      columns: const [
                        DataColumn(label: Text('Môn Học', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Giữa Kỳ', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Cuối Kỳ', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      // Chuyển đổi danh sách grades thành các DataRow
                      rows: grades.map((grade) {
                        return DataRow(cells: [
                          DataCell(Text(grade.subject)),
                          DataCell(Text(grade.midtermScore.toString())),
                          DataCell(Text(grade.finalScore.toString())),
                        ]);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}