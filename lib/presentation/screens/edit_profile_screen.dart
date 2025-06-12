import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_finance/domain/app_user.dart';
import 'package:smart_finance/presentation/screens/profile_screen.dart';
import 'package:smart_finance/widget/profile_widget.dart';
import 'package:smart_finance/widget/textfield_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfileScreen> {
  late AppUser userEditable;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  Future<void> _loadCurrentUserData() async {
    try {
      // Obtener el usuario actualmente logueado
      final User? currentUser = FirebaseAuth.instance.currentUser;
      
      if (currentUser == null) {
        setState(() {
          errorMessage = "No hay usuario logueado";
          isLoading = false;
        });
        return;
      }

      // Obtener los datos del usuario desde Firestore
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users') // Ajusta el nombre de tu colección
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        
        // Crear el objeto AppUser con los datos obtenidos usando fromMap
        userEditable = AppUser.fromMap(userData);
      } else {
        // Si no existe el documento, crear uno con los datos básicos de Firebase Auth
        userEditable = AppUser(
          uid: currentUser.uid,
          name: currentUser.displayName?.split(' ').first ?? '',
          lastName: currentUser.displayName?.split(' ').skip(1).join(' ') ?? '',
          email: currentUser.email ?? '',
          phone: '',
          photoUrl: currentUser.photoURL,
          riskProfile: null,
        );
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error al cargar los datos: $e";
        isLoading = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    try {
      setState(() {
        isLoading = true;
      });

      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      // Guardar en Firestore usando el método toMap()
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .set({
        ...userEditable.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Actualizar el perfil de Firebase Auth si es necesario
      await currentUser.updateDisplayName('${userEditable.name} ${userEditable.lastName}');
      
      // Actualizar UserPreference si lo usas
      //UserPreference.myUser.name = userEditable.name;
      //UserPreference.myUser.email = userEditable.email;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cambios guardados exitosamente'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getRiskProfileName(RiskProfile profile) {
    switch (profile) {
      case RiskProfile.conservador:
        return 'Conservador';
      case RiskProfile.moderado:
        return 'Moderado';
      case RiskProfile.arriesgado:
        return 'Arriesgado';
    }
  }

  String _getRiskProfileDescription(RiskProfile profile) {
    switch (profile) {
      case RiskProfile.conservador:
        return 'Prefiere inversiones seguras con menor riesgo';
      case RiskProfile.moderado:
        return 'Busca un equilibrio entre riesgo y rentabilidad';
      case RiskProfile.arriesgado:
        return 'Acepta mayor riesgo por mayor rentabilidad potencial';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando datos del usuario...'),
            ],
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadCurrentUserData,
                child: Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: userEditable.photoUrl ?? '',
            isEdit: true,
            onClicked: () async {
              // Aquí puedes implementar la lógica para cambiar la imagen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Funcionalidad de cambio de imagen próximamente')),
              );
            },
          ),
          const SizedBox(height: 24),
          
          // Campo Nombre
          TextFieldWidget(
            label: 'Nombre',
            text: userEditable.name,
            onChanged: (name) {
              setState(() {
                userEditable.name = name;
              });
            },
          ),
          const SizedBox(height: 16),
          
          // Campo Apellido
          TextFieldWidget(
            label: 'Apellido',
            text: userEditable.lastName,
            onChanged: (lastName) {
              setState(() {
                userEditable.lastName = lastName;
              });
            },
          ),
          const SizedBox(height: 16),
          
          // Campo Email
          TextFieldWidget(
            label: 'Email',
            text: userEditable.email,
            onChanged: (email) {
              setState(() {
                userEditable.email = email;
              });
            },
          ),
          const SizedBox(height: 16),
          
          // Campo Teléfono
          TextFieldWidget(
            label: 'Teléfono',
            text: userEditable.phone,
            onChanged: (phone) {
              setState(() {
                userEditable.phone = phone;
              });
            },
          ),
          const SizedBox(height: 16),
          
          // Selector de Perfil de Riesgo
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Perfil de Riesgo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                ...RiskProfile.values.map((profile) {
                  return RadioListTile<RiskProfile>(
                    title: Text(_getRiskProfileName(profile)),
                    subtitle: Text(
                      _getRiskProfileDescription(profile),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    value: profile,
                    groupValue: userEditable.riskProfile,
                    onChanged: (RiskProfile? value) {
                      setState(() {
                        userEditable.riskProfile = value;
                      });
                    },
                  );
                }).toList(),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Botón Guardar
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              elevation: 2,
            ),
            onPressed: isLoading ? null : _saveChanges,
            child: isLoading 
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text("Guardando..."),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save),
                      SizedBox(width: 8),
                      Text("Guardar cambios"),
                    ],
                  ),
          ),
          const SizedBox(height: 16),
          
          // Botón Cancelar
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
              side: BorderSide(color: Colors.grey.shade300),
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
            onPressed: isLoading ? null : () {
              Navigator.of(context).pop();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cancel_outlined),
                SizedBox(width: 8),
                Text("Cancelar"),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
