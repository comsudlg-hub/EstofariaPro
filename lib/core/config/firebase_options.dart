import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          "DefaultFirebaseOptions não suportado para esta plataforma.",
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyBJncfY83tmHerhBWVPDKAZia1538ycAy8",
    authDomain: "estofariapro.firebaseapp.com",
    projectId: "estofariapro",
    storageBucket: "estofariapro.firebasestorage.app",
    messagingSenderId: "945698899262",
    appId: "1:945698899262:web:demo1234567890",
    measurementId: "G-XXXXXXX",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBJncfY83tmHerhBWVPDKAZia1538ycAy8",
    appId: "1:945698899262:android:c1cd7b86e2807a8e9b586f",
    messagingSenderId: "945698899262",
    projectId: "estofariapro",
    storageBucket: "estofariapro.firebasestorage.app",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyAlP3k_b-mocIzsJIfsvx1Mmj34uqSdhCI",
    appId: "1:945698899262:ios:5cd3c326d76e6d169b586f",
    messagingSenderId: "945698899262",
    projectId: "estofariapro",
    storageBucket: "estofariapro.firebasestorage.app",
    iosClientId:
        "945698899262-c1e22sq2bu0f3ff81lbcoijpit0gb7cn.apps.googleusercontent.com",
    iosBundleId: "com.example.estofariaproApp",
  );
}
