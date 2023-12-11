import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kpinza_mobile/class/Project.dart';

class AppUser {
  String uid;
  String email;
  String alias;
  List<Project> projects;

  AppUser({
    required this.uid,
    required this.email,
    required this.alias,
    List<Project>? projects,
  }) : projects = projects ?? [];

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'alias': alias,
      'projects': projects.map((project) => project.toMap()).toList(),
    };
  }

  static AppUser fromFirebaseUser(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      alias: '',
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'email': email,
      'alias': alias,
    };
  }

  static AppUser fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data() ?? {};
    return AppUser(
      uid: snapshot.id,
      email: data['email'] ?? '',
      alias: data['alias'] ?? '',
    );
  }

  AppUser copyWith({
    String? uid,
    String? email,
    String? alias,
    List<Project>? projects,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      alias: alias ?? this.alias,
      projects: projects ?? this.projects,
    );
  }

  @override
  String toString() {
    return 'AppUser{uid: $uid, email: $email, alias: $alias, projects: $projects}';
  }
}
