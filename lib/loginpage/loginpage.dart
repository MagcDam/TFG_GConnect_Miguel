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

  LoginPage({required this.supabaseClient});

  @override
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
        title: Text(
          'Inicio de Sesión', // Título de la barra de la aplicación
          style: TextStyle(
            color: Colors.red, // Color del texto del título
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 39, 39, 39), // Color de fondo de la barra de la aplicación
      ),
      backgroundColor: const Color.fromARGB(255, 39, 39, 39), // Color de fondo de la pantalla
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Asignación de la clave global al formulario
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico', // Etiqueta del campo de correo electrónico
                  labelStyle: TextStyle(color: Colors.white), // Estilo de la etiqueta
                  filled: true,
                  fillColor: Colors.grey[800], // Color de fondo del campo de entrada
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Borde redondeado
                  ),
                ),
                style: TextStyle(color: Colors.white), // Color del texto
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un correo electrónico'; // Validación de correo electrónico vacío
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0), // Separación entre campos
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña', // Etiqueta del campo de contraseña
                  labelStyle: TextStyle(color: Colors.white), // Estilo de la etiqueta
                  filled: true,
                  fillColor: Colors.grey[800], // Color de fondo del campo de entrada
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Borde redondeado
                  ),
                ),
                style: TextStyle(color: Colors.white), // Color del texto
                obscureText: true, // Mostrar puntos en lugar de texto para la contraseña
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa una contraseña'; // Validación de contraseña vacía
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Separación entre el botón y los campos de entrada
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
                child: Text(
                  'Iniciar Sesión', // Texto del botón
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

// Método para autenticar al usuario utilizando Supabase
Future<void> authenticateUser(BuildContext context) async {
  final Map<String, dynamic> userData = {
    'email': _emailController.text,
    'password': _passwordController.text,
  };

  const String apiUrl = 'https://jvnldlydmjbzrcgcjizc.supabase.co/auth/v1/token?grant_type=password';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI'
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      // La autenticación fue exitosa
      final responseData = jsonDecode(response.body);
      final accessToken = responseData['access_token'];
      final refreshToken = responseData['refresh_token'];
      // Aquí puedes manejar el token de acceso y de actualización según tus necesidades
      print('Autenticación exitosa. Access Token: $accessToken, Refresh Token: $refreshToken');
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const GameList()),
        );
    } else {
      // Si hubo algún error
      print('Error al autenticar usuario: ${response.statusCode}');
      // Aquí puedes manejar el error según tus necesidades, como mostrar un mensaje al usuario
    }
  } catch (error) {
    print('Error al autenticar usuario: $error');
    // Aquí puedes manejar el error según tus necesidades, como mostrar un mensaje al usuario
  }
}

}
