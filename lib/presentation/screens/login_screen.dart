import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginUser() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    ref.read(authControllerProvider.notifier)
        .login(context: context, email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              inputFormatters: [LengthLimitingTextInputFormatter(30)],
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
              inputFormatters: [LengthLimitingTextInputFormatter(12)],
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _loginUser,
                  child: const Text('Iniciar sesión'),
                ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                final email = _emailController.text.trim();
                ref.read(authControllerProvider.notifier)
                    .sendPasswordResetEmail(context: context, email: email);
              },
              child: const Text('¿Olvidaste tu contraseña?'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => context.push('/register'),
              child: const Text('¿No tenés cuenta? Registrate'),
            ),
          ],
        ),
      ),
    );
  }
}
