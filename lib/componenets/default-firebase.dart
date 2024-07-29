import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    // if (kIsWeb) {
    //   // Web
    //   return const FirebaseOptions(
    //     appId: '1:448618578101:web:0b650370bb29e29cac3efc',
    //     apiKey: 'AIzaSyAgUhHU8wSJgO5MVNy95tMT07NEjzMOfz0',
    //     projectId: 'react-native-firebase-testing',
    //     messagingSenderId: '448618578101',
    //   );
    // } else
      if (Platform.isIOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        appId: '1:974570045543:ios:1f69e813f312bade00d4c2',
        apiKey: 'AIzaSyBayX3U1oTHbLab-ErLwFdaX9otlHGElaw',
        projectId: 'athabyar-ec7dd',
        messagingSenderId: '974570045543',
        iosBundleId: 'com.dkmads.athabyar',
      );
    } else {
      // Android
      return const FirebaseOptions(
        appId: '1:974570045543:android:3657e20d6020f91f00d4c2',
        apiKey: 'AIzaSyBayX3U1oTHbLab-ErLwFdaX9otlHGElaw',
        projectId: 'athabyar-ec7dd',
        messagingSenderId: '974570045543',
      );
    }
  }
}