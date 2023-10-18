import 'package:flutter/material.dart';

class AuthGuard extends StatelessWidget {
  final bool isAuthenticated;
  final Widget authenticatedScreen;
  final Widget unauthenticatedScreen;

  const AuthGuard({
    super.key,
    required this.isAuthenticated,
    required this.authenticatedScreen,
    required this.unauthenticatedScreen,
  });

  @override
  Widget build(BuildContext context) {
    return isAuthenticated ? authenticatedScreen : unauthenticatedScreen;
  }
}
