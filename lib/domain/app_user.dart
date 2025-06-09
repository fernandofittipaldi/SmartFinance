import 'movement.dart';
import 'goal.dart';

enum RiskProfile { conservador, moderado, arriesgado }

class AppUser  {
  final String uid;
  final String name;
  final String lastName;
  final String email;
  final String phone;
  final String? photoUrl;
  final RiskProfile? riskProfile;
  final List<Movement> movements;
  final List<Goal> goals;

  AppUser ({
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

  factory AppUser .fromMap(Map<String, dynamic> map) {
    return AppUser (
      uid: map['uid'],
      name: map['name'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      photoUrl: map['photoUrl'],
      riskProfile: map['riskProfile'] != null
          ? RiskProfile.values.byName(map['riskProfile'])
          : null,
      movements: (map['movements'] as List<dynamic>?)
              ?.map((m) => Movement.fromMap(m))
              .toList() ??
          [],
      goals:
          (map['goals'] as List<dynamic>?)?.map((g) => Goal.fromMap(g)).toList() ?? [],
    );
  }
}
