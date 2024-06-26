import 'package:flutter/material.dart';
import 'package:gracieusgalerij/models/song.dart';
import 'package:gracieusgalerij/screens/theme/theme_app.dart';
import 'package:gracieusgalerij/screens/user/song/song_detail.dart';
import 'package:gracieusgalerij/services/song_service.dart';
import 'package:provider/provider.dart';

class SongListAdmin extends StatefulWidget {
  const SongListAdmin({super.key});

  @override
  State<SongListAdmin> createState() => _SongListAdminState();
}

class _SongListAdminState extends State<SongListAdmin> {
  final SongService _songService = SongService();
  bool _deleteMode = false; // State untuk mode penghapusan

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
            padding: const EdgeInsets.only(top: 100, left: 20, right: 10),
            child: FutureBuilder<List<Song>>(
              future: _songService.getAllSongs(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _deleteMode = !_deleteMode;
          });
        },
        backgroundColor: themeProvider.themeMode().thumbColor!,
        shape: const CircleBorder(),
        elevation: 20,
        child: _deleteMode
            ? Icon(Icons.done, color: themeProvider.themeMode().switchColor!)
            : Icon(Icons.delete,
                color: themeProvider.themeMode().switchColor!, size: 30),
      ),
    );
  }

  Widget _buildSongItem(
      BuildContext context, ThemeProvider themeProvider, Song song) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (_deleteMode) {
              _deleteSong(song);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SongDetailScreen(songId: song.id),
                ),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: themeProvider.themeMode().switchBgColor!,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 13),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: song.imageSong != null &&
                          Uri.parse(song.imageSong!).isAbsolute
                      ? Image.network(
                          song.imageSong!,
                          width: 170,
                          height: 158,
                        )
                      : Container(
                          width: 152,
                          height: 158,
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
                  
                ),
                const SizedBox(height: 5),
                Text(
                  '\$${song.price.toString()}',
                  
                ),
              ],
            ),
          ),
        ),
        if (_deleteMode)
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteSong(song);
              },
            ),
          ),
      ],
    );
  }

  void _deleteSong(Song song) async {
    await SongService.deleteSong(song.id);
    setState(() {});
  }
}
