import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gracieusgalerij/models/song.dart';
import 'package:gracieusgalerij/screens/theme/theme_app.dart';
import 'package:provider/provider.dart';

class SongItem extends StatelessWidget {
  final Song song;

  const SongItem({required this.song});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      width: 100,
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFF543310),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FutureBuilder(
                future: FirebaseStorage.instance
                    .ref(song.imageSong!)
                    .getDownloadURL(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return Image.network(
                    snapshot.data!,
                    width: 150,
                    height: 100,
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
          ),
          Text(
            song.songTitle,
            style: TextStyle(
              fontFamily: 'Bayon',
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
