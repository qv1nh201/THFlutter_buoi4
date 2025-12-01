import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLogin = true;
  var _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitAuthForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        // Đăng nhập
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        // Đăng ký
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      var message = 'Đã xảy ra lỗi, vui lòng kiểm tra lại.';
      if (e.message != null) {
        message = e.message!;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      // ResizeToAvoidBottomInset giúp giao diện không bị bàn phím che mất
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // 1. Phần nền Gradient (Màu chuyển sắc)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6A11CB), // Màu tím
                  Color(0xFF2575FC), // Màu xanh dương
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),

          // 2. Nội dung chính
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- LOGO & TÊN APP ---
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    transform: Matrix4.rotationZ(-0.1)..translate(-10.0), // Nghiêng nhẹ tạo kiểu
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepOrange.shade900,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Text(
                      'Shop Online',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 40,
                        fontFamily: 'Anton', // Nếu chưa có font thì nó lấy font mặc định
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),

                  // --- KHUNG ĐĂNG NHẬP (CARD) ---
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 25), // Cách lề 2 bên
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 400, // Giới hạn chiều rộng trên máy tính bảng/web
                        minHeight: 300,
                      ),
                      padding: const EdgeInsets.all(25.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Tiêu đề form
                            Text(
                              _isLogin ? 'Chào mừng trở lại!' : 'Tạo tài khoản mới',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 25),

                            // Ô nhập Email (Được trau chuốt)
                            TextFormField(
                              controller: _emailController,
                              key: const ValueKey('email'),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              ),
                              validator: (value) {
                                if (value == null || !value.contains('@')) {
                                  return 'Email không hợp lệ!';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),

                            // Ô nhập Password
                            TextFormField(
                              controller: _passwordController,
                              key: const ValueKey('password'),
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Mật khẩu',
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              ),
                              validator: (value) {
                                if (value == null || value.length < 6) {
                                  return 'Mật khẩu quá ngắn (tối thiểu 6 ký tự).';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),

                            // Nút Submit hoặc Loading
                            if (_isLoading)
                              const CircularProgressIndicator()
                            else
                              SizedBox(
                                width: double.infinity,
                                height: 50, // Chiều cao nút bấm lớn hơn
                                child: ElevatedButton(
                                  onPressed: _submitAuthForm,
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    backgroundColor: Theme.of(context).primaryColor,
                                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                                  ),
                                  child: Text(
                                    _isLogin ? 'ĐĂNG NHẬP' : 'ĐĂNG KÝ',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 15),

                            // Nút chuyển đổi
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                  _formKey.currentState?.reset(); // Xóa lỗi khi chuyển tab
                                });
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: _isLogin
                                      ? 'Chưa có tài khoản? '
                                      : 'Đã có tài khoản? ',
                                  style: const TextStyle(color: Colors.grey),
                                  children: [
                                    TextSpan(
                                      text: _isLogin ? 'Đăng ký ngay' : 'Đăng nhập',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}