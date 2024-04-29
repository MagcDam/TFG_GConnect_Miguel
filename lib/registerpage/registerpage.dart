import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String supabaseUrl = 'https://jvnldlydmjbzrcgcjizc.supabase.com';
const String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI';

final supabaseClient = SupabaseClient(supabaseUrl, supabaseKey);

class RegisterPage extends StatefulWidget {
  final SupabaseClient supabaseClient;

  RegisterPage({required this.supabaseClient});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registro de Usuario',
          style: TextStyle(
            color: Colors.red, // Texto del AppBar en rojo
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 39, 39, 39), // Color del AppBar en negro
      ),
      backgroundColor: const Color.fromARGB(255, 39, 39, 39), // Color de fondo en negro
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Nombre de usuario',
                  labelStyle: TextStyle(color: Colors.white), // Texto del label en blanco
                  filled: true,
                  fillColor: Colors.grey[800], // Color del campo de texto
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                  ),
                ),
                style: TextStyle(color: Colors.white), // Color del texto en blanco
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un nombre de usuario';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un correo electrónico';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa una contraseña';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirmar contraseña',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, confirma tu contraseña';
                  }
                  if (value != _passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Imprimir los valores para depuración
                    print('Contraseña: ${_passwordController.text}');
                    print('Confirmar contraseña: ${_confirmPasswordController.text}');
                    // Guardar datos en la base de datos de Supabase
                    insertUser(_usernameController.text, _emailController.text, _passwordController.text);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red), // Botón en rojo
                ),
                child: Text(
                  'Registrarse',
                  style: TextStyle(
                    color: Colors.white, // Texto del botón en blanco
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> insertUser(String usuario, String email, String password) async {
    final newUser = {
      'username': usuario,
      'email': email,
      'password': password,
    };

    final response = await widget.supabaseClient.from('usuarios').insert(newUser);

    if (response.error == null) {
      print('Usuario insertado correctamente');
    } else {
      print('Error al insertar usuario: ${response.error}');
    }
  }
}
