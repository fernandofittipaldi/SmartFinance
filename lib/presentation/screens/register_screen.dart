import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;

    ref
        .read(authControllerProvider.notifier)
        .register(
          context: context,
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: _phoneController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                inputFormatters: [LengthLimitingTextInputFormatter(26)],
                validator:
                    (value) => value!.isEmpty ? 'Ingrese su nombre' : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Apellido'),
                inputFormatters: [LengthLimitingTextInputFormatter(26)],
                validator:
                    (value) => value!.isEmpty ? 'Ingrese su apellido' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                inputFormatters: [LengthLimitingTextInputFormatter(15)],
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese su teléfono';
                  }
                  final numericRegex = RegExp(r'^\+?\d{7,15}$');
                  if (!numericRegex.hasMatch(value)) {
                    return 'Ingrese un número válido (solo dígitos, opcional +)';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                inputFormatters: [LengthLimitingTextInputFormatter(30)],
                keyboardType: TextInputType.emailAddress,
                validator:
                    (value) => value!.isEmpty ? 'Ingrese su email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                inputFormatters: [LengthLimitingTextInputFormatter(12)],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese su contraseña';
                  }
                  if (value.length < 8 || value.length > 12) {
                    return 'Debe tener entre 8 y 12 caracteres';
                  }
                  if (!RegExp(
                    r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+$',
                  ).hasMatch(value)) {
                    return 'Debe contener letras y números';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    onPressed: _onRegister,
                    child: const Text("Registrarse"),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}