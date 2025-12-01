import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  // Instance của Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Trạng thái loading để hiển thị vòng quay khi đang xử lý
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Hàm đăng ký tài khoản mới
  Future<String?> register(String email, String password) async {
    _setLoading(true);
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _setLoading(false);
      return null; // Trả về null nghĩa là thành công
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      return _handleAuthError(e); // Trả về thông báo lỗi
    }
  }

  // Hàm đăng nhập
  Future<String?> login(String email, String password) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _setLoading(false);
      return null; // Thành công
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      return _handleAuthError(e);
    }
  }

  // Hàm đăng xuất
  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  // Helper: Cập nhật trạng thái loading
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Helper: Xử lý thông báo lỗi dễ đọc hơn
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email này đã được đăng ký.';
      case 'invalid-email':
        return 'Email không hợp lệ.';
      case 'weak-password':
        return 'Mật khẩu quá yếu.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Sai email hoặc mật khẩu.';
      default:
        return 'Lỗi: ${e.message}';
    }
  }
}