import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gracieusgalerij/models/song.dart';
import 'package:gracieusgalerij/screens/theme/theme_app.dart';
import 'package:gracieusgalerij/screens/user/cart_screen.dart';
import 'package:gracieusgalerij/screens/user/home_screen.dart';
import 'package:gracieusgalerij/screens/user/search_screen.dart';
import 'package:gracieusgalerij/screens/user/user_profile.dart';
import 'package:gracieusgalerij/services/favorite_service.dart';
import 'package:provider/provider.dart';

import 'song/song_detail.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  int _currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
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
                  padding: const EdgeInsets.only(right: 5, top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Container(
                        width: 152,
                        height: 83,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('images/logo.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<Song>>(
                    stream: FavoriteService.getFavoritesForUser(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No favorite songs yet.',
                                style: TextStyle(
                                  fontFamily: 'Bayon',
                                  color: themeProvider.themeMode().switchColor!,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        final data = snapshot.data!;

                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final song = data[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SongDetailScreen(songId: song.id),
                                    ),
                                  );
                                },
                                child: Card(
                                  color:
                                      themeProvider.themeMode().switchBgColor!,
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: song.imageSong != null &&
                                                      song.imageSong!.isNotEmpty
                                                  ? NetworkImage(
                                                      song.imageSong!)
                                                  : const AssetImage(
                                                          'images/default_song.jpeg')
                                                      as ImageProvider,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                song.songTitle,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: themeProvider
                                                      .themeMode()
                                                      .thumbColor!,
                                                  fontFamily: 'Bayon',
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                song.creator,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: themeProvider
                                                      .themeMode()
                                                      .thumbColor!,
                                                  fontFamily: 'Bayon',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              song.isFavorite =
                                                  !song.isFavorite;
                                            });
                                            if (song.isFavorite) {
                                              FavoriteService.addToFavorites(
                                                      song)
                                                  .catchError((error) {
                                                setState(() {
                                                  song.isFavorite = false;
                                                });
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Failed to add to favorites: $error'),
                                                  ),
                                                );
                                              });
                                            } else {
                                              FavoriteService
                                                      .removeFromFavorites(
                                                          song.id)
                                                  .catchError((error) {
                                                setState(() {
                                                  song.isFavorite = true;
                                                });
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Failed to remove from favorites: $error'),
                                                  ),
                                                );
                                              });
                                            }
                                          },
                                          icon: Icon(Icons.favorite,
                                              color: song.isFavorite
                                                  ? Colors.red
                                                  : Colors.green),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ), // Hanya menampilkan jika berada di layar Favorite dan ada favorit
          Positioned(
            bottom: 10,
            left: 27,
            right: 27,
            child: StreamBuilder<List<Song>>(
              stream: FavoriteService.getFavoritesForUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Jika masih dalam proses memuat, tampilkan tombol sebagai SizedBox
                  return SizedBox();
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  // Jika ada data favorit, tampilkan tombol Remove All Favorites
                  return GestureDetector(
                    onTap: () {
                      _removeAllFavorites();
                    },
                    child: Container(
                      height: 50,
                      color: themeProvider.themeMode().switchBgColor!,
                      child: Center(
                        child: Text(
                          'Remove All Favorites',
                          style: TextStyle(
                            color: themeProvider.themeMode().thumbColor!,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  // Jika tidak ada data favorit, jangan tampilkan tombol
                  return SizedBox();
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: themeProvider.themeMode().navbar!,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _navigateToPage(index);
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _currentIndex == 0
                    ? themeProvider.themeMode().navbarIconAct!
                    : themeProvider.themeMode().navbarIcon!,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _currentIndex == 1
                    ? themeProvider.themeMode().navbarIconAct!
                    : themeProvider.themeMode().navbarIcon!,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                _currentIndex == 2 ? 'images/basket.png' : 'images/basket.png',
                width: 24,
                height: 24,
                color: _currentIndex == 2
                    ? themeProvider.themeMode().navbarIconAct!
                    : themeProvider.themeMode().navbarIcon!,
              ),
              label: 'Story',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: _currentIndex == 3
                    ? themeProvider.themeMode().navbarIconAct!
                    : themeProvider.themeMode().navbarIcon!,
              ),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_rounded,
                color: _currentIndex == 4
                    ? themeProvider.themeMode().navbarIconAct!
                    : themeProvider.themeMode().navbarIcon!,
              ),
              label: 'Account',
            ),
          ],
          showUnselectedLabels: false,
          showSelectedLabels: false,
        ),
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
    }
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          switch (index) {
            case 0:
              return const HomeScreen();
            case 1:
              return const SearchScreen();
            case 2:
              return const CartScreen(
                purchasedSongs: [],
              );
            case 3:
              return const FavoriteScreen();
            case 4:
              return const UserProfile();
            default:
              return Container();
          }
        },
      ),
    );
  }

  void _removeAllFavorites() {
    // Implement function to remove all favorites here
    // You can use FavoriteService method to remove all favorites from Firestore
    FavoriteService.removeAllFavorites().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All favorites removed'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove favorites: $error'),
        ),
      );
    });
  }
}
