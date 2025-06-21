import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/app_user.dart';
import 'app_user_provider.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>((
  ref,
) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<bool> {
  final Ref ref;

  AuthController(this.ref) : super(false);

  Future<void> register({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String lastName,
    required String phone,
  }) async {
    state = true;

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user == null) throw Exception("Error de autenticación");

      final appUser = AppUser(
        uid: user.uid,
        name: name,
        lastName: lastName,
        email: email,
        phone: phone,
        photoUrl: null,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(appUser.toMap());

      await user.sendEmailVerification();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Registro exitoso. Revisa tu correo para confirmar tu email.",
            ),
            backgroundColor: Colors.green,
          ),
        );
      }

      await FirebaseAuth.instance.signOut();
      ref.read(appUserProvider.notifier).state = null;

      if (context.mounted) {
        context.go('/login');
      }
    } on FirebaseAuthException catch (e) {
      final translated = _firebaseErrorToSpanish(e.message ?? '');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(translated), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ocurrió un error inesperado'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      state = false;
    }
  }

  String _firebaseErrorToSpanish(String message) {
    if (message.contains('email address is badly formatted')) {
      return 'El correo electrónico no tiene un formato válido.';
    } else if (message.contains('email address is already in use')) {
      return 'Este correo ya está registrado.';
    } else if (message.contains('Password should be at least')) {
      return 'La contraseña debe tener al menos 8 caracteres.';
    }
    return 'Error al registrar: $message';
  }

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    state = true;

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;

      if (user != null && !user.emailVerified) {
        await FirebaseAuth.instance.signOut();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Verificá tu correo antes de ingresar.'),
            ),
          );
        }
        return;
      }

      if (context.mounted) {
        context.go('/balance');
      }
    } on FirebaseAuthException catch (e) {
      final translated = _firebaseErrorToSpanishLogIn(e.message ?? '');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(translated), backgroundColor: Colors.red),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error inesperado al iniciar sesión.')),
        );
      }
    } finally {
      state = false;
    }
  }

  String _firebaseErrorToSpanishLogIn(String message) {
    if (message.contains('empty password must be provided')) {
      return 'Debe ingresar su contraseña.';
    } else if (message.contains('auth credential is incorrect')) {
      return 'Ingrese su contraseña válida.';
    } else if (message.contains('email address is badly')) {
      return 'Ingrese un email válido.';
    }
    return 'Error al ingresar: $message';
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    ref.read(appUserProvider.notifier).state = null;
    if (context.mounted) {
      context.go('/login');
    }
  }

  Future<void> sendPasswordResetEmail({
    required BuildContext context,
    required String email,
  }) async {
    if (email.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ingresá tu email para recuperar la contraseña'),
            backgroundColor: Colors.red
          ),
        );
      }
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Correo enviado para restablecer la contraseña'),
            backgroundColor: Colors.green
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Error al enviar correo')),
        );
      }
    }
  }
}
