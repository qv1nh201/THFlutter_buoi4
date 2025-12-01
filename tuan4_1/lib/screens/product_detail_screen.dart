import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import '../models/product.dart';
import '../providers/cart_provider.dart'; // Import cart provider

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Lấy instance của CartProvider (listen: false vì ta chỉ gọi hàm, không cần vẽ lại UI ở đây)
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${product.price} VND',
              style: const TextStyle(color: Colors.grey, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            const SizedBox(height: 20),
            // Nút thêm vào giỏ hàng
            ElevatedButton.icon(
              onPressed: () {
                // CẬP NHẬT: Truyền đủ thông tin vào hàm addToCart
                cart.addToCart(
                  product.id,
                  product.title,
                  product.price,
                  product.imageUrl,
                );

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã thêm ${product.title} vào giỏ hàng!'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Thêm vào giỏ hàng'),
            ),
          ],
        ),
      ),
    );
  }
}