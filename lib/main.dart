import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gracieusgalerij/favorite2.dart';
import 'package:gracieusgalerij/screens/admin/edit_product_detail_admin.dart';
import 'package:gracieusgalerij/screens/admin/home_admin.dart';
import 'package:gracieusgalerij/screens/theme/constant.dart';
import 'package:gracieusgalerij/screens/theme/theme_app.dart';
import 'package:gracieusgalerij/screens/user/cart_screen.dart';
import 'package:gracieusgalerij/screens/user/fav_screen.dart';
import 'package:gracieusgalerij/screens/user/search_screen.dart';
import 'package:gracieusgalerij/screens/user/home_screen.dart';
import 'package:gracieusgalerij/screens/user/review/review_edit_screen.dart';
import 'package:gracieusgalerij/screens/user/review/review_list_screen.dart';
import 'package:gracieusgalerij/screens/user/song/song%20review.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/user/landing_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/user/song/song_detail.dart';
import 'screens/user/user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLightTheme = prefs.getBool(SPref.isLight) ?? true;

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  runApp(AppStart(
    isLightTheme: isLightTheme,
  ));
}

class AppStart extends StatelessWidget {
  const AppStart({super.key, required this.isLightTheme});
  final bool isLightTheme;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(isLightTheme: isLightTheme),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'TuneMix',
      theme: themeProvider.themeData(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/home_adm',
      routes: {
        '/landing': (context) => const LandingScreen(),
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/home_adm': (context) => const HomeScreenAdmin(),
        '/song_detail': (context) => const SongDetailScreen(songId: ''),
        '/review': (context) => const ReviewListScreen(
              songTitle: '',
            ),
        '/review_edit': (context) => const ReviewEditScreen(),
        '/songreview': (context) => const SongReviewScreen(songId: ''),
        '/cart': (context) => const CartScreen(
              purchasedSongs: [],
            ),
        '/favorite': (context) => const FavoriteScreen(),
        '/fav2': (context) => const FavoriteScreen2(),
        '/edit': (context) => const EditProductDetail(),
        '/user': (context) => const UserProfile(),
        '/search/': (context) => const SearchScreen(),
      },
    );
  }
}
