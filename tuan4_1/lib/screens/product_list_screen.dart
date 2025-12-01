import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // [MỚI] Import để gọi hàm đăng xuất
import '../widgets/product_card.dart';
import '../providers/cart_provider.dart';
import './cart_screen.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // Tạo biến future để lưu trữ kết quả gọi API
  late Future<List<Product>> _productsFuture;
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    // Gọi API một lần khi màn hình khởi tạo
    _productsFuture = _productService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cửa Hàng Online'),
        actions: [
          // 1. Icon Giỏ hàng
          Consumer<CartProvider>(
            builder: (_, cart, ch) => Badge(
              label: Text(cart.itemCount.toString()),
              child: ch,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const CartScreen()),
                );
              },
            ),
          ),

          // 2. [MỚI] Nút Đăng xuất (Logout)
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Đăng xuất',
            onPressed: () {
              // Hiển thị hộp thoại xác nhận cho chắc chắn
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Xác nhận'),
                  content: const Text('Bạn có muốn đăng xuất không?'),
                  actions: [
                    TextButton(
                      child: const Text('Không'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Có'),
                      onPressed: () {
                        Navigator.of(ctx).pop(); // Đóng dialog
                        FirebaseAuth.instance.signOut(); // Thực hiện đăng xuất
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      // Sử dụng FutureBuilder để xử lý dữ liệu bất đồng bộ từ API
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          // Trường hợp 1: Đang tải
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Trường hợp 2: Có lỗi
          else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          // Trường hợp 3: Có dữ liệu
          else if (snapshot.hasData) {
            final products = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (ctx, i) => ProductCard(product: products[i]),
            );
          }
          // Trường hợp còn lại
          else {
            return const Center(child: Text('Không có sản phẩm nào.'));
          }
        },
      ),
    );
  }
}