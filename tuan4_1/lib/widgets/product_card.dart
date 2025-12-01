import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Sử dụng ClipRRect để bo tròn góc ảnh
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          // Hiển thị tên sản phẩm
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          // Hiển thị giá (bạn có thể format lại sau)
          trailing: Text(
            '${product.price}đ',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        // GestureDetector để bắt sự kiện nhấn [cite: 53]
        child: GestureDetector(
          onTap: () {
            // Chuyển hướng sang màn hình chi tiết [cite: 56]
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => ProductDetailScreen(product: product),
              ),
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}