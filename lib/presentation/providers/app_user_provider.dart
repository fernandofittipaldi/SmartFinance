import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/app_user.dart';

class AppUserNotifier extends StateNotifier<AppUser?> {
  AppUserNotifier() : super(null) {
    _init();
  }

  void _init() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final loadedUser = AppUser.fromFirestore(doc);
          state = loadedUser;
        } else {
          state = null;
        }
      } else {
        state = null;
      }
    });
  }

  Future<void> updateProfile({
    required String name,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || state == null) {
      throw Exception('Usuario no autenticado');
    }

    await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
      'name': name,
      'lastName': lastName,
      'email': email,
      'phone': phone,
    });

    if (email != state!.email) {
      await currentUser.verifyBeforeUpdateEmail(email);
    }

    state = state!.copyWith(
      name: name,
      lastName: lastName,
      email: email,
      phone: phone,
    );
  }
}

final appUserProvider = StateNotifierProvider<AppUserNotifier, AppUser?>(
  (ref) => AppUserNotifier(),
);
