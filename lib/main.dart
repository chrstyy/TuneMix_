import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gracieusgalerij/screens/admin/home_admin.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/fav_screen.dart';
import 'screens/home_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/product_detail.dart';
import 'screens/review_list_screen.dart';
import 'screens/user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TuneMix',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      //home:  ProductDetailScreen(productId: ''),
      initialRoute: '/review',
      routes: {
        '/': (context) => const LandingScreen(),
        '/view': (context) => const UserProfile(),
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
        '/cart': (context) => const CartScreen(),
        '/favorites': (context) => const FavoriteScreen(),
        '/home': (context) => const HomeScreen(),
        '/home_adm': (context) => const HomeScreenAdmin(),
        '/review': (context) => const ReviewListScreen(),
        '/product_detail': (context) => SongDetailScreen(
            songId: ModalRoute.of(context)?.settings.arguments as String),
      },
    );
  }
}
