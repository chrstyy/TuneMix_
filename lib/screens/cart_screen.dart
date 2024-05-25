import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _cartItems = [
    CartItem(
      productName: 'Crop Sweater',
      price: 99.99,
      quantity: 1,
      image: 'images/product_image.png',
    ),
    CartItem(
      productName: 'Denim Jeans',
      price: 59.99,
      quantity: 2,
      image: 'images/product_image_2.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF8F4E1),
                  Color(0xFFAF8F6F),
                ],
                stops: [0.33, 1],
                begin: AlignmentDirectional(0, -1),
                end: AlignmentDirectional(0, 1),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.only(right: 20, top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0x004B39EF),
                            elevation: 0,
                            side: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          child: Image.asset('images/arrowback.png', width: 35, height: 35),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Cart',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Battambang'
                              ),
                            ),
                            Text(
                              '${_cartItems.length} Items',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'Battambang',
                              ),
                            ),
                          ],
                        ),
                        //utk tulisan your cart n brp byk items
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        ),
                      ],
                    ),
                  ),
                  // Cart Items List
SingleChildScrollView(
  child: Column(
    children: [
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _cartItems.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF543310),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 80,  // Ukuran lebih kecil
                              height: 80,  // Ukuran lebih kecil
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage(_cartItems[index].image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _cartItems[index].productName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Battambang',
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        '\$${_cartItems[index].price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        ' x ${_cartItems[index].quantity}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Total: \$${(_cartItems[index].price * _cartItems[index].quantity).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton(
                              onSelected: (value) {
                                // Handle the menu selection
                                if (value == 'edit') {
                                  // Edit action
                                } else if (value == 'delete') {
                                  // Delete action
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ],
  ),
)


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String productName;
  final double price;
  final int quantity;
  final String image;

  CartItem({
    required this.productName,
    required this.price,
    required this.quantity,
    required this.image,
  });
}
