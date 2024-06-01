import 'package:flutter/material.dart';
import 'package:gracieusgalerij/models/song.dart';
import 'package:gracieusgalerij/services/favorite_service.dart';
import 'package:gracieusgalerij/services/song_service.dart';
import '../../services/cart_service.dart';
import 'cart_screen.dart';
import 'fav_screen.dart';

class SongDetailScreen extends StatefulWidget {
  const SongDetailScreen({Key? key, required this.songId}) : super(key: key);

  final String songId;

  @override
  State<SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  final db = SongService();
  final _fav = FavoriteService();
  late Stream<List<Song>> favoriteSongsStream;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Song>(
        future: db.getSongById(widget.songId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading song'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Song not found'));
          }

          final song = snapshot.data!;
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
                                    MaterialPageRoute(builder: (context) => const CartScreen(purchasedSongs: [],)),
                                  );
                                },
                                child: Image.asset('images/cart.png', width: 35, height: 35),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 40, right: 20),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const FavoriteScreen()),
                                  );
                                },
                                icon: Icon(
                                  isFavorite 
                                    ? Icons.favorite  
                                    : Icons.favorite_border, 
                                  color: isFavorite ? Colors.red : Colors.green, 
                                  size: 35,
                                ),
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
                                image: song.imageSong != null
                                  ? DecorationImage(
                                      image: NetworkImage(song.imageSong!),
                                      fit: BoxFit.cover,
                                    )
                                  : null, 
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
                                      song.songTitle,
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'Bayon',
                                      ),
                                    ),
                                    Text(
                                      '\$${song.price}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFFFF8A00),
                                        fontFamily: 'Battambang',
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Creator: ',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Bayon',
                                              color: Color(0xFFFF8A00), 
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${song.creator}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Bayon',
                                              color: Colors.black, 
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Description: \n',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Bayon',
                                              color: Color(0xFFFF8A00), 
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${song.description}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Battambang',
                                              color: Colors.black, 
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Arrangement: \n',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Bayon',
                                              color: Color(0xFFFF8A00), 
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${song.arangement}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Battambang',
                                              color: Colors.black, 
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2,),
                                   ElevatedButton(
                                      onPressed: () {
                                        CartService.addToCart(song);
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            Future.delayed(Duration(seconds: 3), () {
                                              Navigator.of(context).pop(true);
                                            });
                                           return const AlertDialog(
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 80,
                                                  ),
                                                  SizedBox(height: 20),
                                                  Text(
                                                    'Added to Cart',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0XFFF1B26F),
                                        shape: const ContinuousRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                        ),
                                        elevation: 5.0,
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      ),
                                      child: const Text(
                                        'ADD TO CART',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'BAYON',
                                          color: Color(0XFF543310),
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
          );
        },
      ),
    );
  }
}
