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
      title: 'Registro de Usuario',
      home: RegistrationScreen(supabaseClient: supabaseClient),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  final SupabaseClient supabaseClient;

  RegistrationScreen({required this.supabaseClient});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  late String username;
  late String email;
  late String password;
  late String confirmPassword;
  late String genre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre de usuario'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un nombre de usuario';
                  }
                  return null;
                },
                onSaved: (value) {
                  username = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Correo electrónico'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un correo electrónico';
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirmar contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, confirma tu contraseña';
                  }
                  if (value != password) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
                onSaved: (value) {
                  confirmPassword = value!;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Género de videojuego'),
                value: genre,
                onChanged: (String? newValue) {
                  setState(() {
                    genre = newValue!;
                  });
                },
                items: <String>['Acción', 'Aventura', 'Estrategia', 'RPG', 'Deportes']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecciona un género de videojuego';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Guardar datos en la base de datos de Supabase
                    insertUser(username, email, password, genre);
                  }
                },
                child: Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> insertUser(String usuario, String email, String password, String genre) async {
    final newUser = {
      'username': usuario, // Utiliza el parámetro 'usuario' en lugar de la variable 'username'
      'email': email,
      'password': password,
      'genre': genre,
    };

    final response = await widget.supabaseClient.from('usuarios').insert(newUser); // Usa la instancia de supabaseClient desde MyApp

    if (response.error == null) {
      print('Usuario insertado correctamente');
    } else {
      print('Error al insertar usuario: ${response.error}');
    }
  }

}
