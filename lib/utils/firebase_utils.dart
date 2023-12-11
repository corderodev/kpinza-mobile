// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';
import 'package:kpinza_mobile/class/Project.dart';
import 'package:kpinza_mobile/class/User.dart';
import 'package:kpinza_mobile/screens/AuthScreen.dart';

class FirebaseUtils {
  static final DatabaseReference _database = FirebaseDatabase.instance.ref();

  static Future<void> saveUser(AppUser user) async {
    await _database.child('users').child(user.uid).set({
      'uid': user.uid,
      'name': user.alias,
      'email': user.email,
    });
  }

  static Future<List<Project>> obtenerProyectosDesdeFirebase(
      String userUid) async {
    try {
      var snapshotEvent = await _database
          .child('users')
          .child(userUid)
          .child('projects')
          .once();
      DataSnapshot snapshot = snapshotEvent.snapshot;

      if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> projectsMap =
            snapshot.value as Map<dynamic, dynamic>;
        List<Project> proyectos = [];

        projectsMap.forEach((key, value) {
          Map<String, dynamic> projectData = value.cast<String, dynamic>();

          if (projectData.containsKey('userId') &&
              projectData['userId'] == userUid) {
            List<Stage> stages = [];
            if (projectData.containsKey('stages') &&
                projectData['stages'] is List) {
              stages = (projectData['stages'] as List).map((stage) {
                Map<String, dynamic> stageData = stage.cast<String, dynamic>();
                return Stage.fromMap(stageData);
              }).toList();
            }

            proyectos.add(
              Project(
                id: key.toString(),
                name: projectData['name'],
                supervisor: projectData['supervisor'],
                stages: stages,
              ),
            );
          }
        });

        return proyectos;
      } else {
        return [];
      }
    } catch (e) {
      print('Error al obtener proyectos desde Firebase: $e');
      return [];
    }
  }

  static Stream<List<Project>> projectsStreamFromFirebase() {
    String? userUid = UserGlobal.uid;
    if (userUid != null) {
      return FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userUid)
          .child('projects')
          .onValue
          .map((event) {
        final projects = <Project>[];
        if (event.snapshot.value != null &&
            event.snapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> projectsMap =
              event.snapshot.value as Map<dynamic, dynamic>;
          projects.addAll(projectsMap.entries.map((entry) {
            return Project(
              id: entry.key.toString(),
              name: entry.value['name'],
              supervisor: entry.value['supervisor'],
            );
          }));
        }
        return projects;
      });
    } else {
      print('Error: El uid del usuario es nulo');
      return Stream.value([]);
    }
  }

  static Future<Project?> obtenerProyectoPorIdDesdeFirebase(
      String userUid, String projectId) async {
    try {
      var snapshotEvent = await _database
          .child('users')
          .child(userUid)
          .child('projects')
          .child(projectId)
          .once();
      DataSnapshot snapshot = snapshotEvent.snapshot;

      if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> projectData =
            snapshot.value as Map<dynamic, dynamic>;

        List<Stage> stages = [];
        if (projectData.containsKey('stages') &&
            projectData['stages'] is List) {
          stages = (projectData['stages'] as List).map((stage) {
            Map<String, dynamic> stageData = stage.cast<String, dynamic>();
            return Stage.fromMap(stageData);
          }).toList();
        }

        return Project(
          id: projectId,
          name: projectData['name'],
          supervisor: projectData['supervisor'],
          stages: stages,
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error al obtener proyecto desde Firebase: $e');
      return null;
    }
  }

  static Future<void> saveProject(String userId, Project project) async {
    try {
      await _database
          .child('users')
          .child(userId)
          .child('projects')
          .child(project.id)
          .set({
        'id': project.id,
        'name': project.name,
        'supervisor': '',
        'stages': [],
      });
    } catch (e) {
      print('Error al guardar el proyecto: $e');
    }
  }

  static Future<void> saveBrief(
      String userUid,
      String projectId,
      int totalTasks,
      int completedTasks,
      int inProgressTasks,
      int pendingTasks) async {
    try {
      final briefRef =
          _database.child('users/$userUid/projects/$projectId/brief');
      await briefRef.set({
        'totalTasks': totalTasks,
        'completedTasks': completedTasks,
        'inProgressTasks': inProgressTasks,
        'pendingTasks': pendingTasks,
      });
    } catch (e, stackTrace) {
      print('Error al guardar el brief en Firebase: $e\n$stackTrace');
      throw e;
    }
  }

  static Future<void> saveStage(
      String userUid, String projectId, Stage stage) async {
    try {
      final stageRef =
          _database.child('users/$userUid/projects/$projectId/stages').push();
      await stageRef.set({
        'name': stage.name,
        'tasks': stage.tasks.map((task) => task.toMap()).toList(),
      });
    } catch (e, stackTrace) {
      print('Error al guardar la etapa en Firebase: $e\n$stackTrace');
      throw e;
    }
  }

  static Future<void> saveTask(
      String userUid, String projectId, String stageId, Task task) async {
    try {
      final taskRef = _database
          .child('users/$userUid/projects/$projectId/stages/$stageId/tasks')
          .push();
      await taskRef.set({
        'name': task.name,
        'responsable': task.responsable ?? '',
        'status': task.status,
        'startDate': task.startDate.toString(),
        'dueDate': task.dueDate.toString(),
        'estimatedTime': task.estimatedTime,
        'realTime': task.realTime,
        'realStartDate': task.realStartDate.toString(),
        'realDueDate': task.realDueDate.toString(),
      });
    } catch (e, stackTrace) {
      print('Error al guardar la tarea en Firebase: $e\n$stackTrace');
      throw e;
    }
  }

  static Future<void> updateProjectName(
      String userUid, String projectName, String newName) async {
    try {
      await _database
          .child('users')
          .child(userUid)
          .child('projects')
          .child(projectName)
          .update({'name': newName});
    } catch (e, stackTrace) {
      print('Error al actualizar el nombre del proyecto: $e\n$stackTrace');
      throw e;
    }
  }

  static Future<void> updateProjectSupervisor(
      String userUid, String projectId, String newSupervisor) async {
    try {
      await _database
          .child('users')
          .child(userUid)
          .child('projects')
          .child(projectId)
          .update({'supervisor': newSupervisor});
    } catch (e, stackTrace) {
      print('Error al actualizar el supervisor del proyecto: $e\n$stackTrace');
      throw e;
    }
  }

  static Future<void> deleteProject(String userUid, String projectName) async {
    try {
      await _database
          .child('users')
          .child(userUid)
          .child('projects')
          .child(projectName)
          .remove();
    } catch (e, stackTrace) {
      print('Error al eliminar el proyecto: $e\n$stackTrace');
      throw e;
    }
  }
}
