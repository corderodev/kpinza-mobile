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

  static AppUser fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      email: map['email'],
      alias: map['alias'],
      projects: (map['projects'] as List<dynamic>?)
              ?.map((project) => Project.fromMap(project))
              .toList() ??
          [],
    );
  }
}
