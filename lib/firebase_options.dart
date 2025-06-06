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
    apiKey: 'AIzaSyA3xuaC_ouIx--A8DEKd8BTbLJNH5wwZGE',
    appId: '1:58085505136:web:fcf51fd9a0b3cd56ef1cb5',
    messagingSenderId: '58085505136',
    projectId: 'smartirrigation-af901',
    authDomain: 'smartirrigation-af901.firebaseapp.com',
    databaseURL: 'https://smartirrigation-af901-default-rtdb.firebaseio.com',
    storageBucket: 'smartirrigation-af901.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA1sjk4_wL-G7XXQberS2kxbPSnWWf1Vqc',
    appId: '1:58085505136:android:e0e29d94ed7743bbef1cb5',
    messagingSenderId: '58085505136',
    projectId: 'smartirrigation-af901',
    databaseURL: 'https://smartirrigation-af901-default-rtdb.firebaseio.com',
    storageBucket: 'smartirrigation-af901.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA3xuaC_ouIx--A8DEKd8BTbLJNH5wwZGE',
    appId: '1:58085505136:web:266d033ad4f4d71bef1cb5',
    messagingSenderId: '58085505136',
    projectId: 'smartirrigation-af901',
    authDomain: 'smartirrigation-af901.firebaseapp.com',
    databaseURL: 'https://smartirrigation-af901-default-rtdb.firebaseio.com',
    storageBucket: 'smartirrigation-af901.firebasestorage.app',
  );
}
