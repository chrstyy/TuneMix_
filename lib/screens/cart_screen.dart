import 'package:flutter/material.dart';
import 'package:gracieusgalerij/screens/product_detail.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItem> _cartItems = [
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

  double getTotalPayment() {
    double total = 0;
    _cartItems.forEach((item) {
      total += item.price * item.quantity;
    });
    return total;
  }

void _showPaymentSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Payment:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '\$${getTotalPayment().toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select Payment Method:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                RadioListTile(
                  title: const Text('Credit Card'),
                  value: 'credit_card',
                  groupValue: selectedPayment,
                  onChanged: (value) {
                    setState(() {
                      selectedPayment = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: const Text('QRIS'),
                  value: 'qris',
                  groupValue: selectedPayment,
                  onChanged: (value) {
                    setState(() {
                      selectedPayment = value.toString();
                    });
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedPayment == 'qris') {
                            _processQRISPayment(context);
                          } else {
                            _processOtherPaymentMethods(context);
                          }
                        },
                        child: const Text(
                          'Proceed to Payment',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontFamily: 'BelleFair'
                          ),),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentSuccessScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontFamily: 'BelleFair'
                          ),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

   void _processQRISPayment(BuildContext context) {
    String currentDate = DateTime.now().toString().substring(0, 10);
    String companyName = 'Gracieus Galerij';
    String qrCode = 'qr.link/uX31lR'; // Replace with actual QR code

    Navigator.pop(context); // Close the BottomSheet
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Details:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Gracieus Galerij\n'
                '$currentDate\n'
                'Total Payment: \$${getTotalPayment().toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'QR Code:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Image.asset(
                'images/qr.png', // Replace with your QR code image asset
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the BottomSheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentSuccessScreen(),
                    ),
                  );
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _processOtherPaymentMethods(BuildContext context) {
    // Implement your other payment methods logic here
    // For demonstration purposes, navigate to success screen
    Navigator.pop(context); // Close the BottomSheet
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessScreen(),
      ),
    );
  }

  String? selectedPayment = 'credit_card';


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
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => ProductDetailScreen(cartItem: _cartItems[index]),
                                                      ),
                                                    );
                                                  } else if (value == 'delete') {
                                                    // Delete action
                                                  }
                                                },
                                                itemBuilder: (context) => [
                                                  const PopupMenuItem(
                                                    value: 'edit',
                                                    child: Text(
                                                      'Edit',
                                                      style: TextStyle(
                                                        fontFamily: 'Battambang',
                                                        fontSize: 15
                                                      ),),
                                                  ),
                                                  const PopupMenuItem(
                                                    value: 'delete',
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                        fontFamily: 'Battambang',
                                                        fontSize: 15
                                                      ),),
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
                         const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _showPaymentSheet(context);
                          },
                          child: const Text('Payment'),
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

class PaymentSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Success'),
      ),
      body: const Center(
        child: Text(
          'Payment Successful!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}