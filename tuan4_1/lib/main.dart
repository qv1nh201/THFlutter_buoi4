import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import để dùng StreamBuilder
import './screens/product_list_screen.dart';
import './screens/auth_screen.dart'; // Import màn hình đăng nhập mới tạo
import './providers/cart_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => CartProvider(),
      child: MaterialApp(
        title: 'Cửa Hàng Online',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // SỬ DỤNG STREAMBUILDER ĐỂ KIỂM TRA ĐĂNG NHẬP
        home: StreamBuilder(
          // Lắng nghe thay đổi trạng thái đăng nhập từ Firebase
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            // Nếu đang chờ kiểm tra token...
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            // Nếu đã có dữ liệu user (đã đăng nhập) -> Vào trang danh sách sản phẩm
            if (userSnapshot.hasData) {
              return const ProductListScreen();
            }
            // Nếu chưa đăng nhập -> Vào trang Auth
            return const AuthScreen();
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}