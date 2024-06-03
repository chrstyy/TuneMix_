import 'package:flutter/material.dart';
import 'package:gracieusgalerij/models/song.dart';
import 'package:gracieusgalerij/screens/theme/theme_app.dart';
import 'package:gracieusgalerij/screens/user/song/song_detail.dart';
import 'package:gracieusgalerij/services/song_service.dart';
import 'package:provider/provider.dart';

class SongList extends StatefulWidget {
  const SongList({super.key});

  @override
  State<SongList> createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  final SongService _songService = SongService();

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: themeProvider.themeMode().gradientColors!,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 1),
              child: Row(
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
                  const SizedBox(width: 10),
                  Text(
                    'Song List',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Bayon',
                      color: themeProvider.themeMode().switchBgColor!,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: FutureBuilder<List<Song>>(
              future: _songService.getAllSongs(), // Fetching all songs
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No data available.'),
                      );
                    }

                    final List<Song> data = snapshot.data!;
                    return GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return _buildSongItem(
                            context, themeProvider, data[index]);
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongItem(
      BuildContext context, ThemeProvider themeProvider, Song song) {
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
        decoration: BoxDecoration(
          color: themeProvider.themeMode().switchBgColor!,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 13),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: song.imageSong != null &&
                      Uri.parse(song.imageSong!).isAbsolute
                  ? Image.network(
                      song.imageSong!,
                      width: 152,
                      height: 158,
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
  }
}
