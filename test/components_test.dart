import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kpinza_mobile/components/Project.dart';
import 'package:kpinza_mobile/components/ProjectList.dart';

void main() {
  test('Project and Stage Classes Test', () {
    final stage = Stage(name: 'Etapa 1');
    final project = Project(name: 'Proyecto 1', stages: [stage]);

    expect(stage.name, 'Etapa 1');

    expect(project.name, 'Proyecto 1');

    expect(project.stages, hasLength(1));

    final newStage = stage.copyWith(name: 'Nueva Etapa');
    expect(newStage.name, 'Nueva Etapa');
  });

  testWidgets('ProjectList Widget Test', (WidgetTester tester) async {
    final projects = [Project(name: 'Proyecto 1'), Project(name: 'Proyecto 2')];

    Project? deletedProject;
    await tester.pumpWidget(MaterialApp(
      home: ProjectList(
        projects: projects,
        onDelete: (project) {
          deletedProject = project;
        },
        changeProjectName: (project, name) {},
      ),
    ));

    expect(find.byType(ProjectList), findsOneWidget);

    expect(find.text('Proyecto 1'), findsOneWidget);
    expect(find.text('Proyecto 2'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete).first);
    expect(deletedProject, projects.first);
  });
}
