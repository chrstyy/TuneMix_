import 'package:flutter/material.dart';
import 'package:gracieusgalerij/models/song.dart';
import 'package:gracieusgalerij/screens/admin/song_detail_admin.dart';
import 'package:gracieusgalerij/screens/theme/theme_app.dart';
import 'package:gracieusgalerij/services/song_service.dart';
import 'package:provider/provider.dart';

class WidgetRecommendation extends StatelessWidget {
  WidgetRecommendation({super.key});

  final SongService _songService = SongService();

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Align(
      alignment: const AlignmentDirectional(-1, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FutureBuilder<List<Song>>(
          future: _songService.getSongRecommend(count: 5), // Ambil lagu berdasarkan rekomendasi
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
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: data.map((song) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SongDetailAdminScreen(songId: song.id), // Pass the selected song ID to detail screen
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          width: 200,
                          height: 260, // Sesuaikan tinggi agar sama dengan WidgetOffer
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
                                        width: 182,
                                        height: 188,
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
                                
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '\$${song.price.toString()}',
                                
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
            }
          },
        ),
      ),
    );
  }
}
