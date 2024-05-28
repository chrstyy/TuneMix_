import 'package:flutter/material.dart';
import 'package:gracieusgalerij/services/product_service.dart';
import '../models/product.dart';
import 'cart_screen.dart';
import 'fav_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key, required this.productId}) : super(key: key);

  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  final db = ProductService();
  late Stream<List<Product>> favoriteProductsStream;

  @override
  void initState() {
    super.initState();
    favoriteProductsStream = db.getFavoriteProducts('user_id'); // Ganti dengan user_id yang sesuai
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Product>(
        future: db.getProductById(widget.productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading product'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Product not found'));
          }

          final product = snapshot.data!;
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFF8F4E1),
                      Color(0xFFAF8F6F),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: ElevatedButton(
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
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 40, right: 20),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const CartScreen()),
                                  );
                                },
                                child: Image.asset('images/cart.png', width: 35, height: 35),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 40, right: 20),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const FavoriteScreen()),
                                  );
                                },
                                child: Image.asset('images/heart.png', width: 35, height: 35),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Container(
                              width: 353,
                              height: 304,
                              decoration: BoxDecoration(
                                color: const Color(0xFF543310),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(product.imageProduct),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 220,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: SingleChildScrollView(
                              child: Container(
                                width: 393,
                                height: 598,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      product.productName,
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'Bayon',
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '\$${product.price}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFFFF8A00),
                                        fontFamily: 'Battambang',
                                      ),
                                    ),
                                    Text(
                                      product.description,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
