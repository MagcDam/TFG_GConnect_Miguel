import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

// URL y clave de autenticación de Supabase
const String supabaseUrl = 'https://jvnldlydmjbzrcgcjizc.supabase.com';
const String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI';

class RegisterPage extends StatefulWidget {
  final SupabaseClient supabaseClient;

  RegisterPage({required this.supabaseClient});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>(); // Clave global para el formulario
  late TextEditingController _usernameController; // Controlador para el nombre de usuario
  late TextEditingController _emailController; // Controlador para el correo electrónico
  late TextEditingController _passwordController; // Controlador para la contraseña
  late TextEditingController _confirmPasswordController; // Controlador para confirmar la contraseña

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(); // Inicialización del controlador del nombre de usuario
    _emailController = TextEditingController(); // Inicialización del controlador del correo electrónico
    _passwordController = TextEditingController(); // Inicialización del controlador de la contraseña
    _confirmPasswordController = TextEditingController(); // Inicialización del controlador para confirmar la contraseña
  }

  @override
  void dispose() {
    _usernameController.dispose(); // Liberar el controlador del nombre de usuario
    _emailController.dispose(); // Liberar el controlador del correo electrónico
    _passwordController.dispose(); // Liberar el controlador de la contraseña
    _confirmPasswordController.dispose(); // Liberar el controlador para confirmar la contraseña
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de Usuario', // Título de la página de registro
          style: TextStyle(
            color: Colors.red, // Color del texto del título
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 39, 39, 39), // Color de fondo de la barra de aplicación
      ),
      backgroundColor: const Color.fromARGB(255, 39, 39, 39), // Color de fondo de la pantalla
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Asignación de la clave global al formulario
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _usernameController, // Asignación del controlador para el nombre de usuario
                decoration: InputDecoration(
                  labelText: 'Nombre de usuario', // Etiqueta del campo de nombre de usuario
                  labelStyle: const TextStyle(color: Colors.white), // Estilo de la etiqueta
                  filled: true,
                  fillColor: Colors.grey[800], // Color de fondo del campo de texto
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                  ),
                ),
                style: const TextStyle(color: Colors.white), // Color del texto
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un nombre de usuario'; // Validación de nombre de usuario vacío
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0), // Separador entre campos
              TextFormField(
                controller: _emailController, // Asignación del controlador para el correo electrónico
                decoration: InputDecoration(
                  labelText: 'Correo electrónico', // Etiqueta del campo de correo electrónico
                  labelStyle: const TextStyle(color: Colors.white), // Estilo de la etiqueta
                  filled: true,
                  fillColor: Colors.grey[800], // Color de fondo del campo de texto
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                  ),
                ),
                style: const TextStyle(color: Colors.white), // Color del texto
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un correo electrónico'; // Validación de correo electrónico vacío
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0), // Separador entre campos
              TextFormField(
                controller: _passwordController, // Asignación del controlador para la contraseña
                decoration: InputDecoration(
                  labelText: 'Contraseña', // Etiqueta del campo de contraseña
                  labelStyle: const TextStyle(color: Colors.white), // Estilo de la etiqueta
                  filled: true,
                  fillColor: Colors.grey[800], // Color de fondo del campo de texto
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                  ),
                ),
                style: const TextStyle(color: Colors.white), // Color del texto
                obscureText: true, // Ocultar el texto de la contraseña
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa una contraseña'; // Validación de contraseña vacía
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0), // Separador entre campos
              TextFormField(
                controller: _confirmPasswordController, // Asignación del controlador para confirmar la contraseña
                decoration: InputDecoration(
                  labelText: 'Confirmar contraseña', // Etiqueta del campo de confirmación de contraseña
                  labelStyle: const TextStyle(color: Colors.white), // Estilo de la etiqueta
                  filled: true,
                  fillColor: Colors.grey[800], // Color de fondo del campo de texto
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                  ),
                ),
                style: const TextStyle(color: Colors.white), // Color del texto
                obscureText: true, // Ocultar el texto de la contraseña
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, confirma tu contraseña'; // Validación de confirmación de contraseña vacía
                  }
                  if (value != _passwordController.text) {
                    return 'Las contraseñas no coinciden'; // Validación de coincidencia de contraseñas
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0), // Separador entre el botón y los campos de entrada
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Imprimir los valores para depuración
                    print('Contraseña: ${_passwordController.text}');
                    print('Confirmar contraseña: ${_confirmPasswordController.text}');
                    // Guardar datos en la base de datos de Supabase
                    insertUser(context);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red), // Color de fondo del botón en rojo
                ),
                child: const Text(
                  'Registrarse', // Texto del botón de registro
                  style: TextStyle(
                    color: Colors.white, // Color del texto del botón en blanco
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para insertar un nuevo usuario en la base de datos de Supabase
  Future<void> insertUser(BuildContext context) async {
    //pop up error 
    print('Estoy dentro de insert user');
    final Map<String, dynamic> userData = {
      'username': _usernameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    const String apiUrl = 'https://jvnldlydmjbzrcgcjizc.supabase.co/rest/v1/users';

    print('Antes de insertar');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI'
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201) {
      print('Usuario insertado correctamente.');
      } else {
      // Si hubo algún error
      print('Error al insertar usuario: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al insertar usuario: $error');
    }

    print('despues de insertar');

  }
}
