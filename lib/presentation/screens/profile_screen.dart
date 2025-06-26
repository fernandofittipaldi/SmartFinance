import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_finance/domain/app_user.dart';
import 'package:smart_finance/presentation/providers/app_user_provider.dart';
import 'package:smart_finance/presentation/screens/main_scaffold.dart';
import 'package:smart_finance/presentation/screens/risk_profile_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool _fieldsInitialized = false;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    try {
      await ref
          .read(appUserProvider.notifier)
          .updateProfile(
            name: _nameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
          );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Perfil actualizado')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al actualizar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appUser = ref.watch(appUserProvider);

    if (appUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_fieldsInitialized) {
      _nameController.text = appUser.name;
      _lastNameController.text = appUser.lastName;
      _emailController.text = appUser.email;
      _phoneController.text = appUser.phone;
      _fieldsInitialized = true;
    }

    return MainScaffold(
      currentIndex: 5,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Perfil',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _nameController,
                  inputFormatters: [LengthLimitingTextInputFormatter(26)],
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Campo obligatorio'
                              : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _lastNameController,
                  inputFormatters: [LengthLimitingTextInputFormatter(26)],
                  decoration: const InputDecoration(labelText: 'Apellido'),
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Campo obligatorio'
                              : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _emailController,
                  inputFormatters: [LengthLimitingTextInputFormatter(30)],
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Campo obligatorio';
                    }
                    final emailRegex = RegExp(
                      r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                    );
                    if (!emailRegex.hasMatch(value)) return 'Correo inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _phoneController,
                  inputFormatters: [LengthLimitingTextInputFormatter(15)],
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Campo obligatorio';
                    }
                    if (value.length < 6 || value.length > 15) {
                      return 'Teléfono inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  readOnly: true,
                  initialValue: _formatRiskProfile(appUser.riskProfile),
                  decoration: const InputDecoration(
                    labelText: 'Perfil de Riesgo',
                  ),
                  style: const TextStyle(color: Colors.black),
                ),

                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("Guardar Cambios"),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Confirmar Cambios'),
                            content: const Text(
                              '¿Confirma guardar los cambios?',
                            ),
                            actions: [
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(false),
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                                child: const Text('Sí'),
                              ),
                            ],
                          ),
                    );

                    if (confirm == true && _formKey.currentState!.validate()) {
                      await _updateProfile();
                    }
                  },
                ),

                const SizedBox(height: 36),

                ElevatedButton.icon(
                  icon: const Icon(Icons.assessment),
                  label: const Text("Evaluar tu Perfil de Riesgo"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RiskProfileScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatRiskProfile(RiskProfile? profile) {
    switch (profile) {
      case RiskProfile.conservative:
        return 'Conservador';
      case RiskProfile.moderate:
        return 'Moderado';
      case RiskProfile.aggressive:
        return 'Arriesgado';
      default:
        return 'Sin evaluar';
    }
  }
}
