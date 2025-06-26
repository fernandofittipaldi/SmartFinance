import 'movement.dart';
import 'goal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum RiskProfile { conservative, moderate, aggressive }

extension RiskProfileExtension on RiskProfile {
  String get displayName {
    switch (this) {
      case RiskProfile.conservative:
        return 'Conservador';
      case RiskProfile.moderate:
        return 'Moderado';
      case RiskProfile.aggressive:
        return 'Arriesgado';
    }
  }
}

class AppUser {
  final String uid;
  final String name;
  final String lastName;
  final String email;
  final String phone;
  final String? photoUrl;
  final RiskProfile? riskProfile;
  final List<Movement> movements;
  final List<Goal> goals;

  AppUser({
    required this.uid,
    required this.name,
    required this.lastName,
    required this.email,
    required this.phone,
    this.photoUrl,
    this.riskProfile,
    this.movements = const [],
    this.goals = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'riskProfile': riskProfile?.name,
      'movements': movements.map((m) => m.toMap()).toList(),
      'goals': goals.map((g) => g.toMap()).toList(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      name: map['name'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      photoUrl: map['photoUrl'],
      riskProfile: map['riskProfile'] != null
          ? RiskProfile.values.byName(map['riskProfile'])
          : null,
      movements: (map['movements'] as List<dynamic>?)
              ?.map((m) => Movement.fromMap(m))
              .toList() ??
          [],
      goals: (map['goals'] as List<dynamic>?)
              ?.map((g) => Goal.fromMap(g, id: ''))
              .toList() ??
          [],
    );
  }

  factory AppUser.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return AppUser.fromMap(data, snapshot.id);
  }

  AppUser copyWith({
    String? name,
    String? lastName,
    String? email,
    String? phone,
    String? photoUrl,
    RiskProfile? riskProfile,
    List<Movement>? movements,
    List<Goal>? goals,
  }) {
    return AppUser(
      uid: uid,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      riskProfile: riskProfile ?? this.riskProfile,
      movements: movements ?? this.movements,
      goals: goals ?? this.goals,
    );
  }
}
