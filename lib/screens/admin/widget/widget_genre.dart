import 'package:flutter/material.dart';
import 'package:gracieusgalerij/screens/admin/song_genre.dart';
import 'package:provider/provider.dart';
import 'package:gracieusgalerij/services/song_service.dart';
import 'package:gracieusgalerij/screens/theme/theme_app.dart';

class WidgetGenre extends StatelessWidget {
  WidgetGenre({Key? key}) : super(key: key);

  final SongService _songService = SongService();

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return FutureBuilder<List<String>>(
      future: _songService.getGenres(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No genres available.'));
            }

            final List<String> genres = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: genres.map((genre) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SongGenreScreen(genre: genre),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        elevation: 3,
                        backgroundColor: const Color(0xFFF1B26F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        genre,
                        style: const TextStyle(
                          fontFamily: 'Bayon',
                          color: Colors.black,
                          letterSpacing: 0,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
        }
      },
    );
  }
}