import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gconnect/gameliststate/gameliststate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

// URL y clave de autenticación de Supabase
const String supabaseUrl = 'https://jvnldlydmjbzrcgcjizc.supabase.com';
const String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI';

final supabaseClient = SupabaseClient(supabaseUrl, supabaseKey);

// Página de inicio de sesión
class LoginPage extends StatefulWidget {
  final SupabaseClient supabaseClient;

  const LoginPage({super.key, required this.supabaseClient});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // Clave global para el formulario
  late TextEditingController _emailController; // Correo electrónico inicializado
  late TextEditingController _passwordController; // Contraseña inicializada

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login', // Título de la barra de la aplicación
          style: TextStyle(
            color: Colors.red, // Color del texto del título
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 39, 39, 39), // Color de fondo de la barra de la aplicación
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
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email', // Etiqueta del campo de correo electrónico
                  labelStyle: const TextStyle(color: Colors.white), // Estilo de la etiqueta
                  filled: true,
                  fillColor: Colors.grey[800], // Color de fondo del campo de entrada
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Borde redondeado
                  ),
                ),
                style: const TextStyle(color: Colors.white), // Color del texto
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please, enter an email'; // Validación de correo electrónico vacío
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0), // Separación entre campos
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password', // Etiqueta del campo de contraseña
                  labelStyle: const TextStyle(color: Colors.white), // Estilo de la etiqueta
                  filled: true,
                  fillColor: Colors.grey[800], // Color de fondo del campo de entrada
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Borde redondeado
                  ),
                ),
                style: const TextStyle(color: Colors.white), // Color del texto
                obscureText: true, // Mostrar puntos en lugar de texto para la contraseña
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please, enter a password'; // Validación de contraseña vacía
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0), // Separación entre el botón y los campos de entrada
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Imprimir los valores para depuración
                    print('Correo electrónico: ${_emailController.text}');
                    print('Contraseña: ${_passwordController.text}');
                    // Autenticarse utilizando Supabase
                    authenticateUser(context);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red), // Color de fondo del botón
                ),
                child: const Text(
                  'Login', // Texto del botón
                  style: TextStyle(
                    color: Colors.white, // Color del texto del botón
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para mostrar un SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

Future<void> authenticateUser(BuildContext context) async {
  final String email = _emailController.text;
  final String password = _passwordController.text;

  const String apiUrl = 'https://jvnldlydmjbzrcgcjizc.supabase.co/auth/v1/token?grant_type=password';

  try {
    // Fetch user from the database based on email
    final userResponse = await http.get(
      Uri.parse('https://jvnldlydmjbzrcgcjizc.supabase.co/rest/v1/users?email=eq.$email'),
      headers: <String, String>{
        'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI', // Replace with your Supabase API key
      },
    );

    if (userResponse.statusCode == 200) {
      final userData = jsonDecode(userResponse.body);

      print(userResponse.body);

      // Check if user exists and password matches
      if (userData.length > 0 && userData[0]['password'] == password) {
        // If user exists and password matches, proceed with authentication
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI', // Replace with your Supabase API key
          },
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
        );

        if (response.statusCode == 200) {
          // Authentication successful
          final responseData = jsonDecode(response.body);
          final accessToken = responseData['access_token'];
          final refreshToken = responseData['refresh_token'];
          print('Authentication successful. Access Token: $accessToken, Refresh Token: $refreshToken');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => GameList(accessToken: accessToken, email: email)),
          );
        } else {
          // Authentication failed
          print('Error al autenticar usuario: ${response.statusCode}');
          _showSnackBar('Error al iniciar sesión, correo electrónico o contraseña incorrectos');
          print(response.body);
        }
      } else {
        // User not found or incorrect password
        print('Usuario no encontrado o contraseña incorrecta');
        _showSnackBar('Error al iniciar sesión, correo electrónico o contraseña incorrectos');
      }
    } else {
      // Error fetching user data
      print('Error al buscar usuario: ${userResponse.statusCode}');
      _showSnackBar('Error al iniciar sesión, intente de nuevo más tarde');
    }
  } catch (error) {
    print('Error al autenticar usuario: $error');
    _showSnackBar('Error al iniciar sesión, intente de nuevo más tarde');
  }
}

}
