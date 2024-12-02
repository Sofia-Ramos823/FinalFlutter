import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reservas_app/models/TipoApartamento.dart';
import 'package:reservas_app/models/user.dart'; // Importa el modelo TipoApartamento

class ApiService {
  // Base URL de la API
  static const String baseUrl =
      'https://apihotel-1.onrender.com/api/tipoApartamentos';
  static const String baseUrlUsers =
      'https://apihotel-1.onrender.com/api/users';

  // Obtener todos los tipos de apartamentos
  Future<List<TipoApartamento>> fetchTipoApartamentos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List jsonData = json.decode(response.body);
        return jsonData.map((e) => TipoApartamento.fromJson(e)).toList();
      } else {
        throw Exception('Error al obtener los tipos de apartamentos');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Crear un nuevo tipo de apartamento
  Future<TipoApartamento> createTipoApartamento(
      TipoApartamento tipoApartamento) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(tipoApartamento.toJson()),
      );

      if (response.statusCode == 201) {
        return TipoApartamento.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al crear el tipo de apartamento');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Actualizar un tipo de apartamento
  Future<TipoApartamento> updateTipoApartamento(
      String id, TipoApartamento tipoApartamento) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(tipoApartamento.toJson()),
      );

      if (response.statusCode == 200) {
        return TipoApartamento.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al actualizar el tipo de apartamento');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Eliminar un tipo de apartamento
  Future<void> deleteTipoApartamento(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200) {
        throw Exception('Error al eliminar el tipo de apartamento');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // -------------------------
  // MÉTODOS PARA USUARIOS
  // -------------------------

  // Obtener todos los usuarios
  Future<List<User>> obtenerUsuarios() async {
    final url = Uri.parse(baseUrlUsers);
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((item) => User.fromJson(item)).toList();
      } else {
        throw Exception('Error al cargar usuarios: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red al cargar usuarios: $e');
    }
  }

  // Crear un usuario
  Future<String> crearUsuario(
      String username, String email, String password) async {
    final url = Uri.parse('$baseUrlUsers/register');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username.trim(),
          "email": email.trim(),
          "password": password,
        }),
      );

      if (response.statusCode == 201) {
        return 'Usuario registrado exitosamente';
      } else {
        final errorBody = jsonDecode(response.body);
        return 'Error al registrar usuario: ${errorBody['message'] ?? 'Desconocido'}';
      }
    } catch (e) {
      return 'Error al intentar registrar usuario: $e';
    }
  }

  Future<String> iniciarSesion(String email, String password) async {
    final url = Uri.parse('$baseUrlUsers/login');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email.trim(),
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        return 'Inicio de sesión exitoso';
      } else {
        final errorBody = jsonDecode(response.body);
        return 'Error de inicio de sesión: ${errorBody['message'] ?? 'Desconocido'}';
      }
    } catch (e) {
      return 'Error al intentar iniciar sesión: $e';
    }
  }

  Future<String> actualizarUsuario(
      String id, String username, String email) async {
    final url = Uri.parse('$baseUrlUsers/$id');
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username.trim(),
          "email": email.trim(),
        }),
      );

      if (response.statusCode == 200) {
        return 'Usuario actualizado exitosamente';
      } else {
        return 'Error al actualizar usuario: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error al intentar actualizar usuario: $e';
    }
  }

  Future<String> eliminarUsuario(String id) async {
    final url = Uri.parse('$baseUrlUsers/$id');
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        return 'Usuario eliminado exitosamente';
      } else {
        return 'Error al eliminar usuario: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error al intentar eliminar usuario: $e';
    }
  }
}
