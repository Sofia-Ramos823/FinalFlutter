import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:reservas_app/services/api_services.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final ApiService _apiService = ApiService();
  List<User> _users = [];
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await _apiService.obtenerUsuarios();
      setState(() {
        _users = users;
      });
    } catch (e) {
      _showSnackBar('Error al cargar usuarios: $e');
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

  void _showUserForm({User? user}) {
    _currentUserId = user?.id;
    _usernameController.text = user?.username ?? '';
    _emailController.text = user?.email ?? '';
    _passwordController.clear();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, color: Colors.teal, size: 30),
                    SizedBox(width: 10),
                    Text(
                      user == null ? 'Nuevo Usuario' : 'Editar Usuario',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de usuario',
                    prefixIcon: Icon(Icons.person_outline, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es requerido' : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es requerido' : null,
                ),
                SizedBox(height: 15),
                if (user == null)
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock, color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) =>
                        value!.isEmpty ? 'Este campo es requerido' : null,
                  ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          side: BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Cancelar'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _saveUser(user),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          'Guardar',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveUser(User? user) async {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop();
      String message;
      try {
        if (user == null) {
          message = await _apiService.crearUsuario(
            _usernameController.text,
            _emailController.text,
            _passwordController.text,
          );
        } else {
          message = await _apiService.actualizarUsuario(
            _currentUserId!,
            _usernameController.text,
            _emailController.text,
          );
        }
        _showSnackBar(message);
        await _loadUsers();
      } catch (e) {
        _showSnackBar('Error: $e');
      }
    }
  }

  Future<void> _deleteUser(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de que quieres eliminar este usuario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final message = await _apiService.eliminarUsuario(id);
        _showSnackBar(message);
        await _loadUsers();
      } catch (e) {
        _showSnackBar('Error al eliminar usuario: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Gestión de Usuarios', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _users.isEmpty
          ? Center(
              child: Text(
                'No hay usuarios disponibles',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Text(
                        user.username.isNotEmpty
                            ? user.username[0].toUpperCase()
                            : '?',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      user.username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(user.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showUserForm(user: user),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteUser(user.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserForm(),
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
      ),
    );
  }
}
