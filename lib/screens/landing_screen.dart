import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gracieusgalerij/screens/auth/continue_with_google.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth/login_screen.dart';
import 'auth/signup_screen.dart';

class Logo extends StatefulWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0.0, 5.0 * _controller.value),
          child: child,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'images/logo.png',
          width: 300,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ContinueWithGoogle(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.easeInOut;

            var scaleTween = Tween(begin: begin, end: end);
            var fadeTween = Tween(begin: 0.0, end: 1.0);

            var curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            var scaleAnimation = scaleTween.animate(curvedAnimation);
            var fadeAnimation = fadeTween.animate(curvedAnimation);

            return ScaleTransition(
              scale: scaleAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in with Google: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer(
        child: Container(
          height: double.infinity,
          padding:
              const EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF8F4E1),
                Color(0xFFAF8F6F),
              ],
              stops: [0.33, 1],
              begin: AlignmentDirectional(0, -1),
              end: AlignmentDirectional(0, 1),
            ),
          ),
          child: Column(
            children: [
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Logo(),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 40, left: 20, right: 20, bottom: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const SignupScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = 0.0;
                                const end = 1.0;
                                const curve = Curves.easeInOut;

                                var scaleTween = Tween(begin: begin, end: end);
                                var fadeTween = Tween(begin: 0.0, end: 1.0);

                                var curvedAnimation = CurvedAnimation(
                                  parent: animation,
                                  curve: curve,
                                );

                                var scaleAnimation =
                                    scaleTween.animate(curvedAnimation);
                                var fadeAnimation =
                                    fadeTween.animate(curvedAnimation);

                                return ScaleTransition(
                                  scale: scaleAnimation,
                                  child: FadeTransition(
                                    opacity: fadeAnimation,
                                    child: child,
                                  ),
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEEF0E5),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                              color: Color(0xFF8FB2AD),
                              width: 2,
                            ),
                          ),
                        ),
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: const Text(
                            'SIGNUP FOR FREE',
                            style: TextStyle(
                              fontFamily: 'OdorMeanChey',
                              color: Color(0xFF304D30),
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 15),
                      child: ElevatedButton(
                        onPressed: _signInWithGoogle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFEEF0E5),
                          foregroundColor: Color(0xFF304D30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                              color: Color(0xFF8FB2AD),
                              width: 2,
                            ),
                          ),
                          minimumSize: const Size(double.infinity, 45),
                        ),
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: const Text(
                            'CONTINUE WITH GOOGLE',
                            style: TextStyle(
                              fontFamily: 'OdorMeanChey',
                              color: Color(0xFF304D30),
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(-2.00, 0.00),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 70),
                        child: RichText(
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'ALREADY HAVE AN ACCOUNT?',
                                style: TextStyle(
                                  fontFamily: 'PragatiNarrow',
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                text: 'LOGIN',
                                style: const TextStyle(
                                  fontFamily: 'OdorMeanChey',
                                  color: Color(0xFF32012F),
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                ),
                                mouseCursor: SystemMouseCursors.click,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            const LoginScreen(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = 0.0;
                                          const end = 1.0;
                                          const curve = Curves.easeInOut;

                                          var scaleTween =
                                              Tween(begin: begin, end: end);
                                          var fadeTween =
                                              Tween(begin: 0.0, end: 1.0);

                                          var curvedAnimation = CurvedAnimation(
                                            parent: animation,
                                            curve: curve,
                                          );

                                          var scaleAnimation = scaleTween
                                              .animate(curvedAnimation);
                                          var fadeAnimation = fadeTween
                                              .animate(curvedAnimation);

                                          return ScaleTransition(
                                            scale: scaleAnimation,
                                            child: FadeTransition(
                                              opacity: fadeAnimation,
                                              child: child,
                                            ),
                                          );
                                        },
                                        transitionDuration:
                                            const Duration(milliseconds: 500),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
