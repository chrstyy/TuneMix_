import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gracieusgalerij/favorite2.dart';
import 'package:gracieusgalerij/screens/admin/edit_product_detail_admin.dart';
import 'package:gracieusgalerij/screens/admin/home_admin.dart';
import 'package:gracieusgalerij/screens/theme/constant.dart';
import 'package:gracieusgalerij/screens/theme/theme_app.dart';
import 'package:gracieusgalerij/screens/user/cart_screen.dart';
import 'package:gracieusgalerij/screens/user/fav_screen.dart';
import 'package:gracieusgalerij/screens/user/home_screen.dart';
import 'package:gracieusgalerij/screens/user/review/review_edit_screen.dart';
import 'package:gracieusgalerij/screens/user/review/review_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/user/landing_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/user/song_detail.dart';
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
      child: MyApp(),
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
      initialRoute: '/fav2',
      routes: {
        '/': (context) => const LandingScreen(),
        '/landing': (context) => const LandingScreen(),
        '/user': (context) => const UserProfile(),
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
        '/cart': (context) => const CartScreen(purchasedSongs: [],),
        '/favorites': (context) => const FavoriteScreen(),
        '/fav2': (context) => const FavoriteScreen2(),
        '/home': (context) => const HomeScreen(),
        '/review': (context) => const ReviewListScreen(),
        '/home_adm': (context) => const HomeScreenAdmin(),
        '/review_edit': (context) => const ReviewEditScreen(),
        '/edit': (context) => const EditProductDetail(),
        '/product_detail': (context) => SongDetailScreen(songId: ''),
      },
    );
  }
}
