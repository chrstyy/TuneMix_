import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gracieusgalerij/models/song.dart';
import 'package:gracieusgalerij/screens/theme/theme_app.dart';
import 'package:gracieusgalerij/services/song_service.dart';
import 'package:provider/provider.dart';

class SongReviewScreen extends StatefulWidget {
  const SongReviewScreen({Key? key, required this.songId}) : super(key: key);

  final String songId;

  @override
  State<SongReviewScreen> createState() => _SongReviewScreenState();
}

class _SongReviewScreenState extends State<SongReviewScreen> {
  final db = SongService();
  double _rating = 0.0;

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
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Center(
                                      child: Column(
                                        children: [
                                          RatingBar.builder(
                                            initialRating: _rating,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                            itemBuilder: (context, _) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              setState(() {
                                                _rating = rating;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            '$_rating',
                                            style: const TextStyle(
                                              fontFamily: 'Bayon',
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          // Simpan nilai rating ke Firestore
                                          await db.updateSongRating(widget.songId, _rating);
                                          
                                          // Beri umpan balik kepada pengguna bahwa nilai rating telah disimpan
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Rating telah disimpan.'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        } catch (e) {
                                          // Tangani kesalahan jika terjadi
                                          ScaffoldMessenger.of(context                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text('Terjadi kesalahan: $e'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }
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
                                        'SIMPAN',
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

