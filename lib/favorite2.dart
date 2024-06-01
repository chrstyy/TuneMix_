import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gracieusgalerij/screens/user/song_detail.dart';

import 'models/song.dart';
import 'services/favorite_service.dart';

class FavoriteScreen2 extends StatefulWidget {
  const FavoriteScreen2({Key? key});

  @override
  State<FavoriteScreen2> createState() => _FavoriteScreen2State();
}

class _FavoriteScreen2State extends State<FavoriteScreen2> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyText1?.color ?? Colors.black;

    return Scaffold(
       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
       appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Favorite", style: TextStyle(color: textColor)),
        backgroundColor: theme.backgroundColor,
      ),
      body: FadeInUp(
        delay: const Duration(milliseconds: 100),
        child:  SizedBox(
          child: FavoriteList()
          )
          )
    );
  }
}

class FavoriteList extends StatelessWidget {
  FavoriteList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Song>>(
      stream: FavoriteService.getFavoritesForUser(),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        child: Icon(
                          Icons.favorite,
                          size: 90.0,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Your Favorited Locations',
                        style: TextStyle(
                          fontFamily: 'fonts/Inter-Black.ttf',
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                );
            }

            final data = snapshot.data!;
            return FadeInUp(
              delay: const Duration(milliseconds: 1000),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final document = data[index];
                  return FadeInUp(
                    delay: Duration(
                        milliseconds: index * 100), // Stagger animations
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SongDetailScreen(songId: document.id,),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            document.imageSong != null &&
                                    Uri.parse(document.imageSong!).isAbsolute
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Image.network(
                                      document.imageSong!,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                      width: 100.0, // Adjust width as needed
                                      height: 100.0,
                                    ),
                                  )
                                : Container(), // Handle cases where image URL is not available
                            const SizedBox(
                                width:
                                    10.0), // Add spacing between image and text
                            Expanded(
                              // Text takes remaining space
                              child: ListTile(
                                title: Text(document.songTitle,
                                    style: const TextStyle(fontSize: 18)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
        }
      },
    );
  }
}
