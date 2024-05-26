import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'fav_screen.dart';
import 'user_profile.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _currentIndex = 2;

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
    String? creditCardNumber;
    String? bankAccountName;
    String? bankName;
    String? password;

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
                              _showCreditCardDetailsSheet(context);
                            }
                          },
                          child: const Text(
                            'Proceed to Payment',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontFamily: 'BelleFair',
                            ),
                          ),
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
                              fontFamily: 'BelleFair',
                            ),
                          ),
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

  void _showCreditCardDetailsSheet(BuildContext context) {
    String? creditCardNumber;
    String? bankAccountName;
    String? bankName;
    String? password;

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
                    'Credit Card Details:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Credit Card Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      creditCardNumber = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Bank Name',
                        border: OutlineInputBorder(),
                      ),
                      value: bankName,
                      items: <String>[
                        'BCA', 
                        'BNI', 
                        'BRI', 
                        'Mandiri',
                        'Danamon',
                        'Bank Mega',
                        'Bank Permata',
                        'Bank Bukopin',
                        'Bank BTN',
                        'Bank CIMB Niaga',
                        'HSBC',
                        'UOB'
                      ]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          bankName = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Validate input
                            if (creditCardNumber != null &&
                                bankAccountName != null &&
                                bankName != null &&
                                password != null) {
                              _processCreditCardPayment(
                                context,
                                creditCardNumber!,
                                bankAccountName!,
                                bankName!,
                                double.parse(getTotalPayment().toStringAsFixed(2)),
                                int.parse(password!),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill in all fields.'),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Proceed to Payment',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontFamily: 'BelleFair',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the bottom sheet
                          },
                          child: const Text(
                            'Close',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontFamily: 'BelleFair',
                            ),
                          ),
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
    final qrisUrl = 'qris://payment?amount=${getTotalPayment()}&merchant=MERCHANT_ID';

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
  padding: const EdgeInsets.all(16),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Text(
        'Scan this QR Code with your banking app:',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 20),
      // Container(
      //   child: QrImage(
      //     data: qrisUrl,
      //     version: QrVersions.auto,
      //     size: 200.0,
      //   ),
      // ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Close'),
      ),
    ],
  ),
);

      },
    );
  }

void _processCreditCardPayment(BuildContext context, String cardNumber, String accountName, String bankName, double totalAmount, int password) {
    // Here you can implement the logic to process the credit card payment
    // For demonstration purposes, we will simply show a success message and navigate to the success screen

    Navigator.pop(context); // Close the bottom sheet

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
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(_cartItems[index].image),
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
                                                        fontFamily: 'Battambang'
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      '\$${_cartItems[index].price.toStringAsFixed(2)}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.orange,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Battambang'
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      'Quantity: ${_cartItems[index].quantity}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Battambang'
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
                                                      ),
                                                    ),
                                                  ),
                                                  const PopupMenuItem(
                                                    value: 'delete',
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                        fontFamily: 'Battambang',
                                                        fontSize: 15
                                                      ),
                                                    ),
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

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(0xFFE2DFD0),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _navigateToPage(index);
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _currentIndex == 0
                    ? Color(0xFF0500FF)
                    :  Colors.black,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _currentIndex == 1
                    ? Color(0xFF0500FF)
                    : Colors.black,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                _currentIndex == 2
                    ? 'images/basket.png'
                    : 'images/basket.png',
                width: 24,
                height: 24,
                color: _currentIndex == 2
                    ?Color(0xFF0500FF)
                    : Colors.black,
              ),
              label: 'Story',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: _currentIndex == 3
                    ? Color(0xFF0500FF)
                    : Colors.black,
              ),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_rounded,
                color: _currentIndex == 4
                    ? Color(0xFF0500FF)
                    : Colors.black,
              ),
              label: 'Account',
            ),
          ],
          showUnselectedLabels: false,
          showSelectedLabels: false,
        ),
      ),
    );
  }

  void _navigateToPage(int index) {
    var routeBuilder;
    switch (index) {
      case 0:
        routeBuilder = '/home';
        break;
      case 1:
        routeBuilder = '/search';
        break;
      case 2:
        routeBuilder = '/basket';
        break;
      case 3:
        routeBuilder = '/fav';
        break;
      case 4:
        routeBuilder = '/account';
        break;
    }

    // if (index == 2) {
    //   Navigator.push(
    //       context,
    //       PageRouteBuilder(
    //         pageBuilder: (context, animation, secondaryAnimation) =>
    //             const StoryListScreen(),
    //         transitionsBuilder:
    //             (context, animation, secondaryAnimation, child) {
    //           const begin = 0.0;
    //           const end = 1.0;
    //           var tween = Tween(begin: begin, end: end);

    //           var fadeOutAnimation = animation.drive(tween);

    //           return FadeTransition(
    //             opacity: fadeOutAnimation,
    //             child: child,
    //           );
    //         },
    //         transitionDuration: const Duration(milliseconds: 500),
    //       ));
    // }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          switch (index) {
            case 0:
             // return const HomeScreen();
            case 1:
             // return const SearchScreen();
            case 2:
             return const CartScreen();
            case 3:
              return const FavoriteScreen();
            case 4:
              return  const UserProfile();
            default:
              return Container();
          }
        },
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

class ProductDetailScreen extends StatelessWidget {
  final CartItem cartItem;

  ProductDetailScreen({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cartItem.productName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(cartItem.image),
            const SizedBox(height: 20),
            Text(
              cartItem.productName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${cartItem.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, color: Colors.orange),
            ),
            const SizedBox(height: 10),
            Text(
              'Quantity: ${cartItem.quantity}',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
