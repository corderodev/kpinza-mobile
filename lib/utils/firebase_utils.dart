import 'package:firebase_database/firebase_database.dart';
import 'package:kpinza_mobile/components/Project.dart';

class FirebaseUtils {
  static final DatabaseReference _database = FirebaseDatabase.instance.ref();

  static Future<List<Project>> obtenerProyectosDesdeFirebase() async {
    try {
      var snapshotEvent = await _database.child('projects').once();
      DataSnapshot snapshot = snapshotEvent.snapshot;

      if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> projectsMap =
            snapshot.value as Map<dynamic, dynamic>;
        List<Project> proyectos = projectsMap.entries.map((entry) {
          return Project(
            id: entry.key.toString(),
            name: entry.value['name'],
            supervisor: entry.value['supervisor'],
            stages: (entry.value['stages'] as List<dynamic>?)
                    ?.map((stage) => Stage.fromMap(stage))
                    .toList() ??
                [],
          );
        }).toList();

        return proyectos;
      } else {
        return [];
      }
    } catch (e) {
      print('Error al obtener proyectos desde Firebase: $e');
      return [];
    }
  }

  static Future<void> saveProject(Project project) async {
    await _database.child('projects').child(project.name).set({
      'name': project.name,
      'supervisor': project.supervisor,
      // Otros campos según la estructura de tu proyecto
    });
  }

  static Future<void> updateProjectName(
      String projectName, String newName) async {
    await _database
        .child('projects')
        .child(projectName)
        .update({'name': newName});
  }

  static Future<void> deleteProject(String projectName) async {
    await _database.child('projects').child(projectName).remove();
  }
}