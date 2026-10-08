/*
 * Personal build: there is no Firebase project behind this app. These values only satisfy
 * Firebase.initializeApp(); analytics, crash reporting, remote config and push are disabled.
 */

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static const FirebaseOptions currentPlatform = FirebaseOptions(
    apiKey: 'AIzaSyDUMMY-personal-build-0000000000000',
    appId: '1:000000000000:android:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'mobileraker-personal',
    storageBucket: 'mobileraker-personal.appspot.com',
  );
}
