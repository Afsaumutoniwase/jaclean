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
    apiKey: 'AIzaSyDM8vmPCi8MyGzOUdcwJ3qA_K0O0AEcpYk',
    appId: '1:550630230566:web:42491e40f353b6f3a2b4e7',
    messagingSenderId: '550630230566',
    projectId: 'jacleaner-afa48',
    authDomain: 'jacleaner-afa48.firebaseapp.com',
    storageBucket: 'jacleaner-afa48.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD44O6J0sgTTgbUVbTOP35T69Eq48-X_zs',
    appId: '1:550630230566:android:f7afbebff3efc1ffa2b4e7',
    messagingSenderId: '550630230566',
    projectId: 'jacleaner-afa48',
    storageBucket: 'jacleaner-afa48.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCaERE6HBcjvsU2Uqow1HH5sD5TMX2DWag',
    appId: '1:550630230566:ios:108351815ab80224a2b4e7',
    messagingSenderId: '550630230566',
    projectId: 'jacleaner-afa48',
    storageBucket: 'jacleaner-afa48.firebasestorage.app',
    iosBundleId: 'com.example.jaclean',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCaERE6HBcjvsU2Uqow1HH5sD5TMX2DWag',
    appId: '1:550630230566:ios:108351815ab80224a2b4e7',
    messagingSenderId: '550630230566',
    projectId: 'jacleaner-afa48',
    storageBucket: 'jacleaner-afa48.firebasestorage.app',
    iosBundleId: 'com.example.jaclean',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDM8vmPCi8MyGzOUdcwJ3qA_K0O0AEcpYk',
    appId: '1:550630230566:web:18867f4fcf060fdea2b4e7',
    messagingSenderId: '550630230566',
    projectId: 'jacleaner-afa48',
    authDomain: 'jacleaner-afa48.firebaseapp.com',
    storageBucket: 'jacleaner-afa48.firebasestorage.app',
  );
}
