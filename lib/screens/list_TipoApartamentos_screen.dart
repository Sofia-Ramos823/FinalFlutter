import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ListTipoApartamento extends StatefulWidget {
  const ListTipoApartamento({super.key});

  @override
  _ListTipoApartamentoState createState() => _ListTipoApartamentoState();
}

class _ListTipoApartamentoState extends State<ListTipoApartamento> {
  List apartments = [];

  @override
  void initState() {
    super.initState();
    fetchApartments();
  }

  // Fetch data from API
  Future<void> fetchApartments() async {
    final response = await http
        .get(Uri.parse('https://apihotel-1.onrender.com/api/tipoApartamentos'));
    if (response.statusCode == 200) {
      setState(() {
        apartments = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load apartments');
    }
  }

  // Create new apartment
  Future<void> createApartment(Map<String, dynamic> newApartment) async {
    final response = await http.post(
      Uri.parse('https://apihotel-1.onrender.com/api/tipoApartamentos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newApartment),
    );

    if (response.statusCode == 201) {
      fetchApartments();
    } else {
      throw Exception('Failed to create apartment');
    }
  }

  // Update apartment
  Future<void> updateApartment(
      String id, Map<String, dynamic> updatedApartment) async {
    final response = await http.put(
      Uri.parse('https://apihotel-1.onrender.com/api/tipoApartamentos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedApartment),
    );

    if (response.statusCode == 200) {
      fetchApartments();
    } else {
      throw Exception('Failed to update apartment');
    }
  }

  // Delete apartment
  Future<void> deleteApartment(String id) async {
    final response = await http.delete(
      Uri.parse('https://apihotel-1.onrender.com/api/tipoApartamentos/$id'),
    );

    if (response.statusCode == 200) {
      fetchApartments();
    } else {
      throw Exception('Failed to delete apartment');
    }
  }

  // Dialog for adding or editing apartments
  Future<void> showApartmentDialog({Map<String, dynamic>? apartment}) async {
    final isEditing = apartment != null;
    final TextEditingController tipoController =
        TextEditingController(text: apartment?['tipoApto'] ?? '');
    final TextEditingController descripcionController =
        TextEditingController(text: apartment?['descripcionApto'] ?? '');
    final TextEditingController capacidadController = TextEditingController(
        text: apartment?['capacidadApto'].toString() ?? '');
    final TextEditingController tamanoController =
        TextEditingController(text: apartment?['tamanoApto'] ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            isEditing ? 'Editar Apartamento' : 'Crear Apartamento',
            style: TextStyle(
                color: Colors.green[800], fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tipoController,
                decoration: InputDecoration(
                  labelText: 'Tipo',
                  labelStyle: TextStyle(color: Colors.green[700]),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[700]!),
                  ),
                ),
              ),
              TextField(
                controller: descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  labelStyle: TextStyle(color: Colors.green[700]),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[700]!),
                  ),
                ),
              ),
              TextField(
                controller: capacidadController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Capacidad',
                  labelStyle: TextStyle(color: Colors.green[700]),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[700]!),
                  ),
                ),
              ),
              TextField(
                controller: tamanoController,
                decoration: InputDecoration(
                  labelText: 'Tamaño',
                  labelStyle: TextStyle(color: Colors.green[700]),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[700]!),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  Text('Cancelar', style: TextStyle(color: Colors.green[800])),
            ),
            TextButton(
              onPressed: () async {
                final newApartment = {
                  'tipoApto': tipoController.text,
                  'descripcionApto': descripcionController.text,
                  'capacidadApto': int.parse(capacidadController.text),
                  'tamanoApto': tamanoController.text,
                  'estado': 'activo',
                };

                if (isEditing) {
                  await updateApartment(apartment['_id'], newApartment);
                } else {
                  await createApartment(newApartment);
                }

                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: Text(
                isEditing ? 'Guardar' : 'Crear',
                style: TextStyle(color: Colors.green[800]),
              ),
            ),
          ],
        );
      },
    );
  }

  // Navigate to Apartment Details Screen
  void navigateToDetails(Map<String, dynamic> apartment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApartmentDetailsScreen(apartment: apartment),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text(
          'Tipos de Apartamentos',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: apartments.length,
        itemBuilder: (context, index) {
          final apartment = apartments[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Colors.green[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                apartment['tipoApto'],
                style: TextStyle(
                    color: Colors.green[800], fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Capacidad: ${apartment['capacidadApto']} - ${apartment['tamanoApto']}',
                style: TextStyle(color: Colors.green[700]),
              ),
              onTap: () => navigateToDetails(apartment),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.green[700]),
                    onPressed: () => showApartmentDialog(apartment: apartment),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red[700]),
                    onPressed: () async {
                      await deleteApartment(apartment['_id']);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showApartmentDialog(),
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class ApartmentDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> apartment;

  const ApartmentDetailsScreen({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text(
          'Detalles de ${apartment['tipoApto']}',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tipo: ${apartment['tipoApto']}',
              style: TextStyle(
                  color: Colors.green[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Descripción: ${apartment['descripcionApto']}',
              style: TextStyle(color: Colors.green[700], fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Capacidad: ${apartment['capacidadApto']} personas',
              style: TextStyle(color: Colors.green[700], fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Tamaño: ${apartment['tamanoApto']}',
              style: TextStyle(color: Colors.green[700], fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
