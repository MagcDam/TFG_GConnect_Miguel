import 'dart:convert'; // Para manejar la codificación y decodificación JSON
import 'package:flutter/material.dart'; // Framework de UI de Flutter
import 'package:supabase_flutter/supabase_flutter.dart'; // Paquete Supabase para Flutter
import 'package:http/http.dart' as http; // Paquete para realizar solicitudes HTTP

// URL y clave de autenticación de Supabase
const String supabaseUrl = 'https://jvnldlydmjbzrcgcjizc.supabase.com';
const String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI';

class RegisterPage extends StatefulWidget {
  final SupabaseClient supabaseClient;

  const RegisterPage({super.key, required this.supabaseClient});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>(); // Llave para manejar el formulario
  late TextEditingController _usernameController; // Controlador para el campo de usuario
  late TextEditingController _emailController; // Controlador para el campo de email
  late TextEditingController _passwordController; // Controlador para el campo de contraseña
  late TextEditingController _confirmPasswordController; // Controlador para el campo de confirmar contraseña

  @override
  void initState() {
    super.initState();
    // Inicialización de los controladores de texto
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    // Liberación de los recursos de los controladores de texto
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    // Muestra un mensaje en una SnackBar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  bool _isValidPassword(String password) {
    // Validación de la contraseña (mínimo 6 caracteres, una mayúscula y un número)
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
          'User register',
          style: TextStyle(
            color: Colors.red,
          ),
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
              // Campo para el email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
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
                    return 'Please, enter an email';
                  }
                  if (!value.contains('@')) {
                    return 'Please, enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              // Campo para la contraseña
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please, enter a password';
                  }
                  if (!_isValidPassword(value)) {
                    return 'Password must be at least 6 characters long, include an uppercase letter and a number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              // Campo para confirmar la contraseña
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm password',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please, confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords don\'t match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Botón de registro
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    insertUser(context);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Función para insertar el usuario
  Future<void> insertUser(BuildContext context) async {
    final Map<String, dynamic> userData = {
      'email': _emailController.text,
      'username': _usernameController.text,
      'password': _passwordController.text,
    };

    // URL para la autenticación y para la tabla
    final String authUrl = 'https://jvnldlydmjbzrcgcjizc.supabase.co/auth/v1/signup';
    final String restUrl = 'https://jvnldlydmjbzrcgcjizc.supabase.co/rest/v1/users';

    try {
      // Registro de usuario
      final authResponse = await http.post(
        Uri.parse(authUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'apikey': supabaseKey,
        },
        body: jsonEncode(userData),
      );

      // Verificación de éxito en el registro
      if (authResponse.statusCode == 200) {
        // Si el registro fue exitoso, también guardamos los datos en la tabla
        final restResponse = await http.post(
          Uri.parse(restUrl),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'apikey': supabaseKey,
          },
          body: jsonEncode(userData),
        );

        // Verificación de éxito en la inserción en la tabla
        if (restResponse.statusCode == 201) {
          _showSnackBar('User registered successfully');
        } else {
          _showSnackBar('Error when registering user in table: ${restResponse.reasonPhrase}');
        }
      } else {
        _showSnackBar('Error when registering user: ${authResponse.reasonPhrase}');
      }
    } catch (error) {
      _showSnackBar('Error when registering user: $error');
    }
  }
}
