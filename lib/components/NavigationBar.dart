import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {
  final int currentIndex;
  final void Function(int) onTabTapped;

  const NavigationBar({
    super.key,
    required this.onTabTapped,
    required this.currentIndex,
  });

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task_alt_rounded),
          label: 'Proyectos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notificaciones',
        ),
      ],
      currentIndex: widget.currentIndex,
      onTap: widget.onTabTapped,
    );
  }
}
