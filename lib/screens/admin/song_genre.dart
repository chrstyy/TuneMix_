import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gracieusgalerij/services/song_service.dart';
import 'package:gracieusgalerij/screens/theme/theme_app.dart';
import 'package:gracieusgalerij/models/song.dart';
import 'package:gracieusgalerij/screens/user/song_detail.dart';

class SongGenreScreen extends StatefulWidget {
  final String genre;

  const SongGenreScreen({Key? key, required this.genre}) : super(key: key);

  @override
  _SongGenreScreenState createState() => _SongGenreScreenState();
}

class _SongGenreScreenState extends State<SongGenreScreen> {
  final SongService _songService = SongService();

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: FutureBuilder<List<Song>>(
        future: _songService.getSongsByGenre(widget.genre),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading songs'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No songs found for this genre'));
          }

          final songs = snapshot.data!;
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
                    Padding(
                      padding: const EdgeInsets.only(top: 40, left: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                            child: Image.asset(
                              'images/arrowback.png',
                              width: 35,
                              height: 35,
                              color: themeProvider.themeMode().switchColor!,
                            ),
                          ),
                         
                          Text(
                            widget.genre.toUpperCase(),
                            style: const TextStyle(
                              fontFamily: 'Bayon',
                              fontSize: 20,
                              color: Colors.black, // Sesuaikan dengan warna yang diinginkan
                            ),
                          ),
                        const SizedBox(width: 5),
                          const Text(
                            'SONGS',
                            style: TextStyle(
                              fontFamily: 'Bayon',
                              fontSize: 20,
                              color: Colors.black, // Sesuaikan dengan warna yang diinginkan
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          final song = songs[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SongDetailScreen(songId: song.id),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity, // Menggunakan lebar maksimal
                              decoration: BoxDecoration(
                                color: themeProvider.themeMode().switchBgColor!,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 5),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: song.imageSong != null &&
                                        Uri.parse(song.imageSong!).isAbsolute
                                        ? Image.network(
                                      song.imageSong!,
                                      width: 162,
                                      height: 168,
                                      fit: BoxFit.cover,
                                    )
                                        : Container(
                                      width: 182,
                                      height: 188,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    song.songTitle,
                                    style: Theme.of(context).textTheme.headline3,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '\$${song.price.toString()}',
                                    style: Theme.of(context).textTheme.headline3,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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
