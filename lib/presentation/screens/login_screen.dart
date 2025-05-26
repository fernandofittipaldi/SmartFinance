import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2, 
        child: Scaffold(
          appBar: AppBar(
            title: Text('Iniciar sesión y registrarse'),
            bottom: TabBar(
              tabs: [
                Tab (text: 'Iniciar sesión'),
                Tab (text: 'Registrarse'),
                ],
              ),
          ),
          body: TabBarView(children: [
            LoginCard(),
            SingupCard(),
            ]
          )
        )
      )
    );
  }
}

class LoginCard extends StatelessWidget{
  Widget build (BuildContext context){
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: (){
                  //Aca se busca el usuario y contra en FireBase
                },
                child: Text('Iniciar sesión'))
            ],
            )
          )
        )
    );
  }  
}

class SingupCard extends StatelessWidget{
  @override
  Widget build (BuildContext context){
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Nombre completo'),
              ),
              SizedBox( height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'Correo electrónico'),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: (){
                  //Logica de crear en la base de Firebase el usuario
                },
                child: Text('Registrarse'))
            ],
          ),
        ),
      ),
    );
  }
}