import './models/product.dart';

// Dữ liệu giả lập dùng chung cho toàn app
final List<Product> DUMMY_PRODUCTS = [
  Product(
    id: 'p1',
    title: 'Áo Thun',
    description: 'Áo thun cotton thoáng mát, thấm hút mồ hôi tốt.',
    price: 200000,
    imageUrl: 'https://picsum.photos/id/1/300/300',
  ),
  Product(
    id: 'p2',
    title: 'Giày Thể Thao',
    description: 'Giày chạy bộ siêu nhẹ, êm ái cho mọi địa hình.',
    price: 500000,
    imageUrl: 'https://picsum.photos/id/2/300/300',
  ),
  Product(
    id: 'p3',
    title: 'Điện thoại',
    description: 'Smartphone đời mới nhất với camera siêu nét.',
    price: 15000000,
    imageUrl: 'https://picsum.photos/id/3/300/300',
  ),
  Product(
    id: 'p4',
    title: 'Laptop',
    description: 'Laptop cấu hình cao, phù hợp cho lập trình viên.',
    price: 25000000,
    imageUrl: 'https://picsum.photos/id/4/300/300',
  ),
];