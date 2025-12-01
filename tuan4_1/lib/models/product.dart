class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  // Hàm factory để tạo Product từ JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(), // API trả về ID là số, ta chuyển thành String
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      // Xử lý an toàn cho giá tiền (có thể là int hoặc double)
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image'] ?? '',
    );
  }
}