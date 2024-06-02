import 'package:flutter/material.dart';
import 'package:gracieusgalerij/screens/user/search_screen.dart';
import 'package:provider/provider.dart';

import '../../models/song.dart';
import '../../services/song_service.dart';
import '../admin/widget/widget_recommend.dart';
import '../admin/widget/widget_offer.dart';
import '../theme/theme_app.dart';
import 'cart_screen.dart';
import 'fav_screen.dart';
import 'song_detail.dart';
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
          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
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
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child:Row(
                    children: [
                      Text(
                       'Special Offer', style: TextStyle(fontFamily: 'Bayon',fontSize: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 220),
                        child: Icon(
                          Icons.notifications,
                          size: 24,
                          ),
                        ),
                    ],
                  ) 
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
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Text(
                    'Category',
                    style: TextStyle(
                      fontFamily: 'Bayon',
                      fontSize: 20,
                    ),
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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                print('Button pressed ...');
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'texthdsjs',
                                style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.black,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                print('Button pressed ...');
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'text',
                                style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                print('Button pressed ...');
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'texthdsjs',
                                style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                print('Button pressed ...');
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'text',
                                style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recommendation',
                              style: TextStyle(
                                fontFamily: 'Bayon',
                                fontSize: 20,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: themeProvider.themeMode().switchColor!,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder<List<Song>>(
                        future: _songService.getSongRecommend(count: 5),
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
          canvasColor: const Color(0xFFE2DFD0),
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
                color:
                    _currentIndex == 0 ? const Color(0xFF0500FF) : Colors.black,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color:
                    _currentIndex == 1 ? const Color(0xFF0500FF) : Colors.black,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                _currentIndex == 2 ? 'images/basket.png' : 'images/basket.png',
                width: 24,
                height: 24,
                color:
                    _currentIndex == 2 ? const Color(0xFF0500FF) : Colors.black,
              ),
              label: 'Story',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color:
                    _currentIndex == 3 ? const Color(0xFF0500FF) : Colors.black,
              ),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_rounded,
                color:
                    _currentIndex == 4 ? const Color(0xFF0500FF) : Colors.black,
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
    var routeBuilder;
    switch (index) {
      case 0:
        routeBuilder = '/home';
        break;
      case 1:
        routeBuilder = '/search';
        break;
      case 2:
        routeBuilder = '/cart';
        break;
      case 3:
        routeBuilder = '/favorites';
        break;
      case 4:
        routeBuilder = '/user';
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