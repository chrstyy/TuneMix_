import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gracieusgalerij/screens/admin/edit_product_detail_admin.dart';
import 'package:gracieusgalerij/screens/cart_screen.dart';
import 'package:gracieusgalerij/screens/fav_screen.dart';
import 'package:gracieusgalerij/screens/home_screen.dart';
import 'package:gracieusgalerij/screens/review_list_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/product_detail.dart';
import 'screens/user_profile.dart';

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
      home: EditProductDetail(),
      debugShowCheckedModeBanner: false,
      // initialRoute: '/',

      // routes: {
      //   '/': (context) => const LandingScreen(),
      //   '/landing': (context) => const LandingScreen(),
      //   '/view': (context) => const UserProfile(),
      //   '/signup': (context) => const SignupScreen(),
      //   '/login': (context) => const LoginScreen(),
      //   '/cart': (context) => const CartScreen(),
      //   '/favorites': (context) => const FavoriteScreen(),
      //   '/home': (context) => const HomeScreen(),
      //   '/review': (context) => const ReviewListScreen(),
      //   //  '/product_detail': (context) =>  ProductDetailScreen(productId: ''),
      // },
      // onGenerateRoute: (settings) {
      //   if (settings.name == '/product_detail') {
      //     final args = settings.arguments as String;
      //     return MaterialPageRoute(
      //       builder: (context) {
      //         builder: (context) => ProductDetailScreen(productId: args['productId'] as String),
      //       },
      //     );
      //   }
      //   return null;
      // },
    );
  }
}
