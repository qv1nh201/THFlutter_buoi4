import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Lấy thông tin user
import 'package:cloud_firestore/cloud_firestore.dart'; // Lưu database
import '../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false; // Biến trạng thái để hiện vòng xoay loading

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItemsList = cart.items.values.toList();
    final cartItemsKeys = cart.items.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Giỏ Hàng Của Bạn"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tổng cộng', style: TextStyle(fontSize: 20)),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '${cart.totalAmount.toStringAsFixed(0)}đ',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.titleLarge?.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  // Nút ĐẶT HÀNG (OrderButton)
                  TextButton(
                    onPressed: (cart.totalAmount <= 0 || _isLoading)
                        ? null // Vô hiệu hóa nút nếu giỏ hàng rỗng hoặc đang tải
                        : () async {
                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        // 1. Lấy thông tin user hiện tại
                        final user = FirebaseAuth.instance.currentUser;

                        // 2. Gửi dữ liệu lên Firestore
                        await FirebaseFirestore.instance.collection('orders').add({
                          'userId': user?.uid, // ID người mua
                          'userEmail': user?.email, // Email người mua
                          'amount': cart.totalAmount, // Tổng tiền
                          'dateTime': DateTime.now().toIso8601String(), // Thời gian đặt
                          'products': cart.items.values.map((cp) => {
                            'id': cp.id,
                            'title': cp.title,
                            'quantity': cp.quantity,
                            'price': cp.price,
                            'imageUrl': cp.imageUrl
                          }).toList(),
                        });

                        // 3. Xóa giỏ hàng sau khi lưu thành công
                        cart.clearCart();

                        // 4. Thông báo thành công
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đặt hàng thành công!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Lỗi đặt hàng: $error'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }

                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator() // Hiện loading nếu đang xử lý
                        : const Text('ĐẶT HÀNG'),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                final item = cartItemsList[i];
                final productId = cartItemsKeys[i];

                return Dismissible(
                  key: ValueKey(item.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    Provider.of<CartProvider>(context, listen: false)
                        .removeItem(productId);
                  },
                  background: Container(
                    color: Theme.of(context).colorScheme.error,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    child: const Icon(Icons.delete, color: Colors.white, size: 40),
                  ),
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(item.imageUrl),
                        ),
                        title: Text(item.title),
                        subtitle: Text(
                            'Tổng: ${(item.price * item.quantity).toStringAsFixed(0)}đ'),
                        trailing: Text('${item.quantity} x'),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}