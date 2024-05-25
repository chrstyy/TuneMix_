import 'package:flutter/material.dart';

class ContinueWithGoogle extends StatefulWidget {
  const ContinueWithGoogle({Key? key}) : super(key: key);

  @override
  State<ContinueWithGoogle> createState() => _ContinueWithGoogleState();
}

class _ContinueWithGoogleState extends State<ContinueWithGoogle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Continue with Google'),
      ),
      body: Center(
        child: Text('Welcome! You have signed in with Google.'),
      ),
    );
  }
}
