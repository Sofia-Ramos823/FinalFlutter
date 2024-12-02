import 'package:flutter/material.dart';
import '../services/api_services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool _isRegistering = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final result = await _apiService.iniciarSesion(
          _emailController.text,
          _passwordController.text,
        );
        _showSnackBar(result);
        if (result.contains('exitoso')) {
          Navigator.of(context).pushReplacementNamed('/main_menu');
        }
      } catch (e) {
        _showSnackBar('Error de inicio de sesión: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final result = await _apiService.crearUsuario(
          _emailController.text.split('@')[0], // Usando email como username
          _emailController.text,
          _passwordController.text,
        );
        _showSnackBar(result);
        if (result.contains('exitosamente')) {
          setState(() {
            _isRegistering = false;
          });
        }
      } catch (e) {
        _showSnackBar('Error de registro: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal, Colors.teal.shade700],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.lock_outline,
                          size: 80,
                          color: Colors.teal,
                        ),
                        SizedBox(height: 20),
                        Text(
                          _isRegistering ? 'Registrarse' : 'Iniciar Sesión',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Correo Electrónico',
                            prefixIcon: Icon(Icons.email, color: Colors.teal),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !value.contains('@')) {
                              return 'Por favor ingrese un correo electrónico válido';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: Icon(Icons.lock, color: Colors.teal),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 6) {
                              return 'La contraseña debe tener al menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : (_isRegistering ? _register : _login),
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  _isRegistering
                                      ? 'Registrarse'
                                      : 'Iniciar Sesión',
                                  style: TextStyle(fontSize: 16),
                                ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isRegistering = !_isRegistering;
                            });
                          },
                          child: Text(
                            _isRegistering
                                ? '¿Ya tienes una cuenta? Inicia sesión'
                                : '¿No tienes una cuenta? Regístrate',
                            style: TextStyle(color: Colors.teal),
                          ),
                        ),
                        if (!_isRegistering)
                          TextButton(
                            onPressed: () {
                              _showSnackBar(
                                  'Funcionalidad de recuperación de contraseña no implementada');
                            },
                            child: Text(
                              '¿Olvidaste tu contraseña?',
                              style: TextStyle(color: Colors.teal),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
