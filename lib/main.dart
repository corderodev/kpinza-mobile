import 'package:flutter/material.dart';
import 'package:kpinza_mobile/screens/AuthGuard.dart';
import 'package:kpinza_mobile/screens/AuthScreen.dart';
import 'package:kpinza_mobile/screens/MainScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final bool _isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kpinza',
      home: AuthGuard(
        isAuthenticated: _isAuthenticated,
        authenticatedScreen: const MainScreen(),
        unauthenticatedScreen: const AuthScreen(),
      ),
    );
  }
}
