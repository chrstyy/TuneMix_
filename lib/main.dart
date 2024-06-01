import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gracieusgalerij/screens/admin/edit_product_detail_admin.dart';
import 'package:gracieusgalerij/screens/admin/home_admin.dart';
import 'package:gracieusgalerij/screens/user/cart_screen.dart';
import 'package:gracieusgalerij/screens/user/fav_screen.dart';
import 'package:gracieusgalerij/screens/user/home_screen.dart';
import 'package:gracieusgalerij/screens/user/review/review_edit_screen.dart';
import 'package:gracieusgalerij/screens/user/review/review_list_screen.dart';
import 'screens/user/landing_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/user/song_detail.dart';
import 'screens/user/user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TuneMix',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/': (context) => const LandingScreen(),
        '/landing': (context) => const LandingScreen(),
        '/view': (context) => const UserProfile(),
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
        //'/cart': (context) => const CartScreen(song: null,),
        '/favorites': (context) => const FavoriteScreen(),
        '/home': (context) => const HomeScreen(),
        '/review': (context) => const ReviewListScreen(),
        '/home_adm': (context) => const HomeScreenAdmin(),
        '/review_edit': (context) => const ReviewEditScreen(),
        '/edit': (context) => const EditProductDetail(),
       '/product_detail': (context) =>  SongDetailScreen(songId: ''),
      },
    );
  }
}
