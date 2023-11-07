import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyC0pb9CFafHoVbt2M5W5PE2ZgKO9n5DCHY",
            authDomain: "mem-chat-permaweb.firebaseapp.com",
            projectId: "mem-chat-permaweb",
            storageBucket: "mem-chat-permaweb.appspot.com",
            messagingSenderId: "1033095123485",
            appId: "1:1033095123485:web:94348ea49be7cea69bacf4",
            measurementId: "G-6FTDSDHDN3"));
  } else {
    await Firebase.initializeApp();
  }
}
