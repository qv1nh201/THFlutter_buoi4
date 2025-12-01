import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  // Hàm lấy danh sách sản phẩm từ API
  Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('https://fakestoreapi.com/products');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Giải mã JSON
        final List<dynamic> data = json.decode(response.body);

        // Chuyển đổi từng phần tử JSON thành object Product
        List<Product> products = data.map((item) => Product.fromJson(item)).toList();
        return products;
      } else {
        throw Exception('Không thể tải sản phẩm');
      }
    } catch (error) {
      throw Exception('Lỗi kết nối: $error');
    }
  }
}