import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const LifeScriptApp());
}

class LifeScriptApp extends StatelessWidget {
  const LifeScriptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeScript AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0E0E10),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C5CE7),
          secondary: Color(0xFF00D2FF),
        ),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}
