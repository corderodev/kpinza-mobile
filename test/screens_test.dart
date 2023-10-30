import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kpinza_mobile/screens/MainScreen.dart';
import 'package:kpinza_mobile/screens/AuthScreen.dart';
import 'package:kpinza_mobile/screens/AuthGuard.dart';
import 'package:kpinza_mobile/components/Project.dart';
import 'package:kpinza_mobile/screens/ProjectDetailScreen.dart';

void main() {
  testWidgets('MainScreen Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainScreen()));

    expect(find.byType(MainScreen), findsOneWidget);
  });

  testWidgets('AuthScreen Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

    expect(find.byType(AuthScreen), findsOneWidget);
  });

  testWidgets('AuthGuard Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: AuthGuard(
        isAuthenticated: true,
        authenticatedScreen: AuthScreen(),
        unauthenticatedScreen: MainScreen(),
      ),
    ));

    expect(find.byType(AuthScreen), findsOneWidget);

    await tester.pumpWidget(const MaterialApp(
      home: AuthGuard(
        isAuthenticated: false,
        authenticatedScreen: AuthScreen(),
        unauthenticatedScreen: MainScreen(),
      ),
    ));

    expect(find.byType(MainScreen), findsOneWidget);
  });

  testWidgets('ProjectDetailScreen Widget Test', (WidgetTester tester) async {
    final project = Project(name: 'Proyecto de Prueba');

    await tester.pumpWidget(MaterialApp(
      home: ProjectDetailScreen(
        project: project,
        onDelete: (p) {},
        changeProjectName: (p, name) {},
      ),
    ));

    expect(find.byType(ProjectDetailScreen), findsOneWidget);
  });
}
