import 'dart:convert'; // Thư viện để mã hóa ảnh thành chữ
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Dùng Firestore thay vì Storage
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  File? _imageFile;
  String? _avatarBase64; // Biến lưu chuỗi ảnh thay vì URL
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Hàm tải dữ liệu người dùng từ Firestore
  Future<void> _loadUserProfile() async {
    if (user == null) return;
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          // Lấy chuỗi ảnh từ field 'avatarBase64'
          _avatarBase64 = docSnapshot.data()?['avatarBase64'];
        });
      }
    } catch (e) {
      print("Lỗi tải profile: $e");
    }
  }

  // Hàm chọn ảnh và lưu thẳng vào Firestore (bỏ qua Storage)
  Future<void> _pickAndSaveImage() async {
    final picker = ImagePicker();
    // Chọn ảnh và giảm chất lượng xuống 50% để chuỗi không quá dài
    // Quan trọng: Phải giảm kích thước để Firestore chấp nhận
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxWidth: 300,
    );

    if (pickedFile != null && user != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _isUploading = true;
      });

      try {
        // 1. Đọc file ảnh thành các byte
        final bytes = await _imageFile!.readAsBytes();

        // 2. Mã hóa byte thành chuỗi Base64
        String base64Image = base64Encode(bytes);

        // 3. Lưu chuỗi này trực tiếp vào Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .set({
          'email': user!.email,
          'role': 'student',
          'avatarBase64': base64Image, // Lưu chuỗi ảnh vào đây
        }, SetOptions(merge: true)); // merge: true để giữ lại dữ liệu cũ nếu có

        setState(() {
          _avatarBase64 = base64Image;
          _isUploading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã cập nhật ảnh đại diện (Lưu vào DB)!')),
          );
        }
      } catch (e) {
        setState(() {
          _isUploading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hồ Sơ Cá Nhân")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade300,
                  // Logic hiển thị ảnh:
                  // 1. Nếu vừa chọn ảnh từ máy -> Hiển thị FileImage
                  // 2. Nếu đã có chuỗi Base64 từ DB -> Giải mã và hiển thị MemoryImage
                  // 3. Không có gì -> Hiển thị null (để hiện icon person)
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : (_avatarBase64 != null
                      ? MemoryImage(base64Decode(_avatarBase64!)) as ImageProvider
                      : null),
                  child: (_imageFile == null && _avatarBase64 == null)
                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 20,
                    child: IconButton(
                      icon: _isUploading
                          ? const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                          : const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                      onPressed: _isUploading ? null : _pickAndSaveImage,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              user?.email ?? "Chưa đăng nhập",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Vai trò: Học sinh",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Lưu ý: Đang sử dụng chế độ lưu ảnh trực tiếp vào Database (Không dùng Storage)",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}