import 'package:flutter/material.dart';

import 'cart_screen.dart';
import 'fav_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedSizeIndex = 0;
  int _selectedColorIndex = -1; 
  int _quantity = 1;

  List<String> _sizes = ['S', 'M', 'L', 'XL'];
  List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];

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
      body: Stack(
        children: [
          Container(
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
                        child: Image.asset('images/arrowback.png',
                            width: 35, height: 35),
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
                            child: Image.asset('images/cart.png',
                                width: 35, height: 35),
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
                            child: Image.asset('images/heart.png',
                                width: 35, height: 35),
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
                            image: const DecorationImage(
                              image: AssetImage('images/product_image.png'),
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
                                const Text(
                                  'Product Name',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Bayon',
                                  ),
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  '\$99.99',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFFFF8A00),
                                    fontFamily: 'Battambang',
                                  ),
                                ),
                                const Text(
                                  '\nRaih tampilan modis dan nyaman dengan Crop Sweater terbaru kami. Dibuat dari bahan berkualitas tinggi yang lembut dan elastis, sweater ini dirancang khusus untuk memberikan kenyamanan maksimal sepanjang hari.'
                                  '\nDengan potongan crop yang trendi, sweater ini sempurna untuk gaya kasual yang chic.',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  width: 380,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1B26F), 
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 322,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Colors',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily: 'Bayon',
                                                      ),
                                                    ),
                                                    Row(
                                                      children: List.generate(
                                                        _colors.length,
                                                        (index) => InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              _selectedColorIndex = index;
                                                            });
                                                          },
                                                          child: Container(
                                                            width: 36,
                                                            height: 36,
                                                            margin: const EdgeInsets.only(left: 8),
                                                            decoration: BoxDecoration(
                                                              color: _colors[index],
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                color: _selectedColorIndex == index
                                                                    ? const Color(0xFF543310)
                                                                    : Colors.transparent,
                                                                width: 4,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Sizes',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily: 'Bayon',
                                                      ),
                                                    ),
                                                    Wrap(
                                                      spacing: 10,
                                                      children: List.generate(
                                                        _sizes.length,
                                                        (index) => InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              _selectedSizeIndex = index;
                                                            });
                                                          },
                                                          child: Container(
                                                            width: 36,
                                                            height: 36,
                                                            decoration: BoxDecoration(
                                                              color: _selectedSizeIndex == index
                                                                  ? const Color(0xFF543310)
                                                                  : Colors.white,
                                                              borderRadius: BorderRadius.circular(25),
                                                              border: Border.all(
                                                                color: const Color(0xFF543310),
                                                                width: _selectedSizeIndex == index ? 2 : 1,
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                _sizes[index],
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: _selectedSizeIndex == index
                                                                      ? Colors.white
                                                                      : Colors.black,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        // Quantity selection
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: _decrementQuantity,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: const Icon(Icons.remove_circle_outline),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              '$_quantity',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            GestureDetector(
                                              onTap: _incrementQuantity,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: const Icon(Icons.add_circle_outline),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Add to cart button
                                        Center(
                                          child: SizedBox(
                                            width: 108,
                                            height: 27,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                // Handle add to cart
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFFFFE8C8),
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: const Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Add to Cart',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
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
      ),
    );
  }
}