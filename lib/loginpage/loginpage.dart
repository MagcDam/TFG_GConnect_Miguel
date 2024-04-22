import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
    // Define las credenciales de tu base de datos de Supabase
  final String supabaseUrl = 'https://jvnldlydmjbzrcgcjizc.supabase.com';
  final String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI';

  @override
  Widget build(BuildContext context) {
    // Configura la conexión con Supabase
    final supabaseClient = SupabaseClient(supabaseUrl, supabaseKey);

    return MaterialApp(
      title: 'Inicio de sesion',
      home: LoginScreen(supabaseClient: supabaseClient),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final SupabaseClient supabaseClient;

  LoginScreen({required this.supabaseClient});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de sesion'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Correo electronico'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el correo electronico';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa una contraseña';
                  }
                  return null;
                },
                onSaved: (value) {
                  password = value!;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Verificar credenciales en la base de datos de Supabase
                    loginUser(email, password);
                  }
                },
                child: Text('Iniciar sesion'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginUser(String email, String password) async {

    final response = await widget.supabaseClient.auth.signInWithPassword(
      email: email, 
      password: password,
    );

    if (response.user != null) {
      print('Inicio de sesion exitoso');
    } else {
      print('Error al iniciar seesion: $response');
    }
  }
}