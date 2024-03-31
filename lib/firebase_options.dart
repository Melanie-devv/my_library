// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBO_gypcYsCWE8hXxOKxJdp9knF8IUAKiE',
    appId: '1:350415770392:web:6f9d5e8b4c8405e178c46d',
    messagingSenderId: '350415770392',
    projectId: 'mylibrary-37fda',
    authDomain: 'mylibrary-37fda.firebaseapp.com',
    storageBucket: 'mylibrary-37fda.appspot.com',
    measurementId: 'G-DVNE0MRLM8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDlrTaDcxG0lIsy2iVcnP_gjeTBLMfCn-Y',
    appId: '1:350415770392:android:4bb310b0626c6cd678c46d',
    messagingSenderId: '350415770392',
    projectId: 'mylibrary-37fda',
    storageBucket: 'mylibrary-37fda.appspot.com',
  );
}
