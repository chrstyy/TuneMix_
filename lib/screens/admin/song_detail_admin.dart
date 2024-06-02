import 'package:flutter/material.dart';
import 'package:gracieusgalerij/models/song.dart';
import 'package:gracieusgalerij/screens/theme/theme_app.dart';
import 'package:gracieusgalerij/screens/user/fav_screen.dart';
import 'package:gracieusgalerij/screens/user/song%20review.dart';
import 'package:gracieusgalerij/services/favorite_service.dart';
import 'package:gracieusgalerij/services/song_service.dart';
import 'package:provider/provider.dart';
import '../../services/cart_service.dart';


class SongDetailAdminScreen extends StatefulWidget {
  const SongDetailAdminScreen({Key? key, required this.songId}) : super(key: key);

  final String songId;

  @override
  State<SongDetailAdminScreen> createState() => _SongDetailAdminScreenState();
}

class _SongDetailAdminScreenState extends State<SongDetailAdminScreen> {
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
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
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
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 40, right: 20),
                            //   child: GestureDetector(
                            //     onTap: () {
                            //       Navigator.pushReplacement(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) => SongReviewScreen(songId: widget.songId), // Pass the songId here
                            //         ),
                            //       );
                            //     },
                            //     child: const Icon(
                            //       Icons.star,
                            //       color: Colors.yellow,
                            //       size: 35,
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(top: 40, right: 20),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const FavoriteScreen(),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
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
                                color: themeProvider.themeMode().switchBgColor!,
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
                                  color: themeProvider.themeMode().switchBgColor!,
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
                                      style: Theme.of(context).textTheme.headline4!,
                                    ),
                                    Text(
                                      '\$${song.price}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFFFF8A00),
                                        fontFamily: 'Battambang',
                                      ),
                                    ),
                                    const SizedBox(height: 5),
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
                                            text: song.creator,
                                            style: Theme.of(context).textTheme.headline3!,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
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
                                            text: song.description,
                                            style: Theme.of(context).textTheme.headline6!,
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
                                            text: song.arangement,
                                            style: Theme.of(context).textTheme.headline6!,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2),
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
