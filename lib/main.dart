import 'package:flutter/material.dart';
import 'package:reservas_app/screens/list_TipoApartamentos_screen.dart';
import 'package:reservas_app/screens/login_screen.dart';
import 'package:reservas_app/screens/user_management_screen.dart';

void main() {
  runApp(const Principal());
}

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reservation App',
      initialRoute: '/', // Página inicial de la app
      routes: {
        '/': (context) => LoginScreen(), // Ruta para la pantalla de Login
        '/main_menu': (context) =>
            const ListTipoApartamento(), // Ruta para la pantalla de ListTipoApartamento
        '/user_management': (context) =>
            UserManagementScreen(), // Ruta para la pantalla de gestión de usuarios
      },
    );
  }
}
