import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Firebase options have not been configured for web.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'Firebase options are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'PUT_YOUR_API_KEY_HERE',
    appId: 'PUT_YOUR_APP_ID_HERE',
    messagingSenderId: 'PUT_YOUR_MESSAGING_SENDER_ID_HERE',
    projectId: 'PUT_YOUR_PROJECT_ID_HERE',
    storageBucket: 'PUT_YOUR_PROJECT_ID_HERE.appspot.com',
  );
}
