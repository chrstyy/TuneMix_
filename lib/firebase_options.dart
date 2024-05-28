// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAX7S-2tk2beQ8D0DHx5tiZo0dB7dA1tLU',
    appId: '1:1062247362235:web:7fd3b3f65b40e36c3f039e',
    messagingSenderId: '1062247362235',
    projectId: 'gracie-c0a95',
    authDomain: 'gracie-c0a95.firebaseapp.com',
    storageBucket: 'gracie-c0a95.appspot.com',
    measurementId: 'G-820V7GD2MG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnmKCDA3HeyCDrPAyjwVsK2Jb086yrGLo',
    appId: '1:1062247362235:android:75f9c7e6fb32dbd73f039e',
    messagingSenderId: '1062247362235',
    projectId: 'gracie-c0a95',
    storageBucket: 'gracie-c0a95.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAjJ0OTRaT1gc-xDIXp4BzJRXgqEJQO-j4',
    appId: '1:1062247362235:ios:0c6ba35828f6de253f039e',
    messagingSenderId: '1062247362235',
    projectId: 'gracie-c0a95',
    storageBucket: 'gracie-c0a95.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAjJ0OTRaT1gc-xDIXp4BzJRXgqEJQO-j4',
    appId: '1:1062247362235:ios:0c6ba35828f6de253f039e',
    messagingSenderId: '1062247362235',
    projectId: 'gracie-c0a95',
    storageBucket: 'gracie-c0a95.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAX7S-2tk2beQ8D0DHx5tiZo0dB7dA1tLU',
    appId: '1:1062247362235:web:fd817d4cc838385e3f039e',
    messagingSenderId: '1062247362235',
    projectId: 'gracie-c0a95',
    authDomain: 'gracie-c0a95.firebaseapp.com',
    storageBucket: 'gracie-c0a95.appspot.com',
    measurementId: 'G-DGEVGS3S15',
  );

}