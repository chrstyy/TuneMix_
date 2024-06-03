import 'package:flutter/material.dart';
import 'package:gracieusgalerij/screens/admin/widget/widget_genre.dart';
import 'package:gracieusgalerij/screens/user/search_screen.dart';
import 'package:gracieusgalerij/screens/user/song/song_list.dart';
import 'package:provider/provider.dart';

import '../../models/song.dart';
import '../../services/song_service.dart';
import '../theme/theme_app.dart';
import 'cart_screen.dart';
import 'fav_screen.dart';
import 'song/song_detail.dart';
import 'user_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final SongService _songService = SongService();

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: themeProvider.themeMode().gradientColors!,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'images/logo.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Special Offer',
                      style: TextStyle(fontFamily: 'Bayon', fontSize: 20),
                    ),
                    const SizedBox(
                      width: 150,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SongList(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Text(
                          'view all',
                          style: TextStyle(
                            color: themeProvider.themeMode().switchColor!,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                FutureBuilder<List<Song>>(
                  future: _songService.getSongSpecialOffer(count: 5),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    final List<Song> data = snapshot.data ?? [];
                    if (data.isEmpty) {
                      return const Center(
                        child: Text('No data available.'),
                      );
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: data.map((song) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
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
                              child: Container(
                                width: 200,
                                height: 260,
                                decoration: BoxDecoration(
                                  color:
                                      themeProvider.themeMode().switchBgColor!,
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
                                              Uri.parse(song.imageSong!)
                                                  .isAbsolute
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
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      song.songTitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3!,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '\$${song.price.toString()}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3!,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Genre',
                        style: TextStyle(
                          fontFamily: 'Bayon',
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    color: themeProvider.themeMode().switchBgColor!,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 0, 5),
                    child: WidgetGenre(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recommendation',
                        style: TextStyle(
                          fontFamily: 'Bayon',
                          fontSize: 20,
                        ),
                      ),
                      FutureBuilder<List<Song>>(
                        future: _songService.getSongRecommend(count: 5),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }
                          final List<Song> data = snapshot.data ?? [];
                          if (data.isEmpty) {
                            return const Center(
                              child: Text('No data available.'),
                            );
                          }
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: data.map((song) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
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
                                    child: Container(
                                      width: 200,
                                      height: 260,
                                      decoration: BoxDecoration(
                                        color: themeProvider
                                            .themeMode()
                                            .switchBgColor!,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 13),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: song.imageSong != null &&
                                                    Uri.parse(song.imageSong!)
                                                        .isAbsolute
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
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            song.songTitle,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3!,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            '\$${song.price.toString()}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3!,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
}
