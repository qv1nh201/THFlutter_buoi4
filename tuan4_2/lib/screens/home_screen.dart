import 'package:flutter/material.dart';
import 'schedule_screen.dart';
import 'grades_screen.dart';
import 'package:provider/provider.dart'; // Import thêm Provider
import '../providers/auth_provider.dart'; // Import AuthProvide

import 'profile_screen.dart'; // Import màn hình hồ sơ
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Biến lưu chỉ số của tab hiện tại
  int _selectedIndex = 0;

  // Danh sách các màn hình tương ứng với các tab
  static const List<Widget> _widgetOptions = <Widget>[
    // Tab 0: Trang chủ (Dashboard)
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            'Xin chào, Học sinh!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('Chọn tính năng bên dưới để tiếp tục.'),
        ],
      ),
    ),
    // Tab 1: Lịch học (Import từ schedule_screen.dart)
    ScheduleScreen(),
    // Tab 2: Điểm số (Import từ grades_screen.dart)
    GradesScreen(),
  ];

  // Hàm xử lý khi người dùng chọn tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản Lý Trường Học"),
        centerTitle: true,
        actions: [
          // Nút mở trang Hồ sơ
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          // Nút Đăng xuất cũ
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      // Hiển thị màn hình tương ứng với tab được chọn
      body: _widgetOptions.elementAt(_selectedIndex),

      // Thanh điều hướng dưới cùng
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Lịch học',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade),
            label: 'Điểm số',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}