import 'dart:convert'; // Para manejar la codificación y decodificación JSON
import 'package:flutter/material.dart'; // Framework de UI de Flutter
import 'package:http/http.dart' as http; // Paquete para realizar solicitudes HTTP

// URL y clave de autenticación de Supabase
const String supabaseUrl = 'https://jvnldlydmjbzrcgcjizc.supabase.co';
const String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'; // Trunca por seguridad

class ChangeInformationPage extends StatefulWidget {
  final String userId; // ID del usuario

  const ChangeInformationPage({super.key, required this.userId});

  @override
  _ChangeInformationPage createState() => _ChangeInformationPage();
}

class _ChangeInformationPage extends State<ChangeInformationPage> {
  final _formKey = GlobalKey<FormState>(); // Clave global para el formulario
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _fetchUserData(); // Obtiene los datos del usuario cuando se inicia el estado
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Función para obtener datos del usuario desde la API
  Future<void> _fetchUserData() async {
    final String restUrl = '$supabaseUrl/rest/v1/users?userId=eq.${widget.userId}';
    final response = await http.get(
      Uri.parse(restUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'apikey': supabaseKey,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final user = data[0];
        _usernameController.text = user['username']; // Establece el nombre de usuario en el controlador
      }
    } else {
      _showSnackBar('Failed to fetch user data: ${response.reasonPhrase}');
      print(response.statusCode);
    }
  }

  // Función para mostrar mensajes Snackbar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Validación de la contraseña
  bool _isValidPassword(String password) {
    if (password.length < 6) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit User',
          style: TextStyle(color: Colors.red),
        ),
        backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      ),
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo para el nombre de usuario
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please, enter a username';
                  }
                  if (value.length < 6) {
                    return 'Username must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              // Campo para la nueva contraseña
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                obscureText: true, // Oculta el texto para contraseñas
                validator: (value) {
                  if (value != null && value.isNotEmpty && !_isValidPassword(value)) {
                    return 'Password must be at least 6 characters long, include an uppercase letter and a number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              // Campo para confirmar la nueva contraseña
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                obscureText: true, // Oculta el texto para contraseñas
                validator: (value) {
                  if (_passwordController.text.isNotEmpty && value != _passwordController.text) {
                    return 'Passwords don\'t match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Botón para actualizar los datos del usuario
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateUser(context); // Llama a la función para actualizar el usuario
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Función para actualizar los datos del usuario en la API
  Future<void> updateUser(BuildContext context) async {
    final Map<String, dynamic> updatedData = {};

    if (_usernameController.text.isNotEmpty) {
      updatedData['username'] = _usernameController.text; // Añade el nombre de usuario actualizado
    }

    if (_passwordController.text.isNotEmpty) {
      if (_passwordController.text == _confirmPasswordController.text) {
        updatedData['password'] = _passwordController.text; // Añade la nueva contraseña
      } else {
        _showSnackBar('Passwords don\'t match');
        return;
      }
    }

    if (updatedData.isEmpty) {
      _showSnackBar('No changes detected');
      return;
    }

    final String restUrl = '$supabaseUrl/rest/v1/users?userId=eq.${widget.userId}';

    try {
      final response = await http.patch(
        Uri.parse(restUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'apikey': supabaseKey,
          'Authorization': 'Bearer $supabaseKey',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        _showSnackBar('User updated successfully');
      } else {
        _showSnackBar('Error updating user: ${response.reasonPhrase}');
      }
    } catch (error) {
      _showSnackBar('Error updating user: $error');
    }
  }
}
