import 'package:flutter/material.dart';
import 'package:kpinza_mobile/screens/AuthScreen.dart';
import 'package:kpinza_mobile/components/NavigationBar.dart'
    as kpinza_component;
import 'package:kpinza_mobile/screens/DataScreen.dart';
import 'package:kpinza_mobile/screens/NotificationScreen.dart';
import 'package:kpinza_mobile/screens/ProjectsScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kpinza'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout), // Icono para el botón
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AuthScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [DataScreen(), ProjectsScreen(), NotificationScreen()],
      ),
      bottomNavigationBar: kpinza_component.NavigationBar(
        onTabTapped: _onTabTapped,
        currentIndex: _currentIndex,
      ),
    );
  }
}
