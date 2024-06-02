import 'package:flutter/material.dart';
import 'package:gracieusgalerij/models/song.dart';
import 'package:gracieusgalerij/screens/theme/theme_app.dart';
import 'package:gracieusgalerij/screens/user/review/review_edit_screen.dart';
import 'package:gracieusgalerij/screens/user/review/review_list_screen.dart';
import 'package:gracieusgalerij/screens/user/song%20review.dart';
import 'package:gracieusgalerij/services/favorite_service.dart';
import 'package:gracieusgalerij/services/song_service.dart';
import 'package:provider/provider.dart';
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
  final SongService _songService = SongService();
  final FavoriteService _favoriteService = FavoriteService();
  late bool _isFavorite;
  late Song song;

  @override
  void initState() {
    super.initState();
    _isFavorite = true;
  }

  void toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    if (_isFavorite) {
      FavoriteService.addToFavorites(song);
    } else {
      FavoriteService.removeFromFavorites(song.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: FutureBuilder<Song>(
        future: _songService.getSongById(widget.songId),
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

          song = snapshot.data!;
          _isFavorite = song.isFavorite;

          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: themeProvider.themeMode().gradientColors!,
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
                            child: Image.asset(
                              'images/arrowback.png',
                              width: 35,
                              height: 35,
                              color: themeProvider.themeMode().switchColor!,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 40, right: 20),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const CartScreen(
                                              purchasedSongs: [],
                                            )),
                                  );
                                },
                                child: Image.asset(
                                  'images/cart.png',
                                  width: 35,
                                  height: 35,
                                  color: themeProvider.themeMode().switchColor!,
                                ),
                              ),
                            ),
                             Padding(
                              padding: const EdgeInsets.only(top: 40, right: 20),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SongReviewScreen(songId: widget.songId), // Pass the songId here
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 35,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 40, right: 20),
                              child: IconButton(
                                onPressed: () {
                                  toggleFavorite();
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  color:
                                      _isFavorite ? Colors.red : Colors.green,
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
                                width: double.infinity,
                                height: 598,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color:
                                      themeProvider.themeMode().switchBgColor!,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      song.songTitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!,
                                    ),
                                    Text(
                                      '\$${song.price}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFFFF8A00),
                                        fontFamily: 'Battambang',
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
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
                                            style: TextStyle(
                                              fontFamily: 'Battambang',
                                              fontSize: 16,
                                              color: themeProvider
                                                  .themeMode()
                                                  .thumbColor!,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
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
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
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
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      child: Text(
                                        'See review',
                                        style: TextStyle(
                                          fontFamily: 'Itim',
                                          color: Colors.orange,
                                          fontSize: 20,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ReviewListScreen(
                                              songTitle: song.songTitle,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        CartService.addToCart(song);
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            Future.delayed(
                                                const Duration(seconds: 3), () {
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0XFFF1B26F),
                                        shape: const ContinuousRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        elevation: 5.0,
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