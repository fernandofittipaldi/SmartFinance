import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_finance/domain/app_user.dart';
import 'package:smart_finance/presentation/screens/edit_profile_screen.dart';
import 'package:smart_finance/presentation/screens/login_screen.dart';
import 'package:smart_finance/presentation/screens/main_scaffold.dart';
import 'package:smart_finance/widget/profile_widget.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
  const ProfileScreen({super.key});
}

class _ProfilePageState extends State<ProfileScreen>{
  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final AppUser user = FirebaseAuth.instance.currentUser as AppUser;

    return MainScaffold(
      currentIndex: 5,
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.photoUrl,
            onClicked: () async{
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
            ),
            const SizedBox(height:12),
            Column(
              children: [
                Text("Haga click en la imagen para modificar",
                style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height:12),
            buildName(user),
            const SizedBox(height:50),
        ],
      ),
    );
  }
}

Widget buildName(AppUser user) => Column(
  children: [
    Text(
      user.name,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)
    ),
    const SizedBox(height:4),
    Text(
      user.email,
      style: TextStyle(color: Colors.grey),
    ),
  ],
);