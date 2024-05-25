import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gracieusgalerij/screens/cart_screen.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'GracieusGalerij',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: CartScreen(),
        initialRoute: '/',
        routes: {
          '/landing': (context) => const LandingScreen(),
          '/view': (context) => const UserProfile(),
          '/signup': (context) => const SignupScreen(),
          '/login': (context) => const LoginScreen(),
        });
  }
}
