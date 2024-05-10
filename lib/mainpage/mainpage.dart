import 'package:flutter/material.dart';
import 'package:gconnect/loginpage/loginpage.dart'; // Importamos la página de inicio de sesión
import 'package:gconnect/registerpage/registerpage.dart'; // Importamos la página de registro
import 'package:supabase_flutter/supabase_flutter.dart'; // Importamos Supabase

// URL y clave de autenticación de Supabase
const String supabaseUrl = 'https://jvnldlydmjbzrcgcjizc.supabase.com';
const String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI';

final supabaseClient = SupabaseClient(supabaseUrl, supabaseKey); // Cliente de Supabase

// Clase que representa la página principal
class mainpage extends StatelessWidget {
  const mainpage({Key? key, required this.supabaseClient}) : super(key: key); // Constructor

  final SupabaseClient supabaseClient; // Cliente de Supabase

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 39, 39, 39), // Color de fondo
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logotfg.png', // Imagen de la aplicación
                width: 500,
                height: 500,
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Alpha 0.1.2', // Versión de la aplicación
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Color de texto
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Navegación a la página de registro
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(supabaseClient: supabaseClient),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red), // Estilo del botón de registro
                ),
                child: const Text(
                  'Get Started', // Texto del botón de registro
                  style: TextStyle(
                    color: Colors.white, // Color de texto
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  // Navegación a la página de inicio de sesión
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => LoginPage(supabaseClient: supabaseClient)
                      ),
                  );
                },
                child: const Text(
                  'Do you already have an account? Log in here!', // Texto para iniciar sesión
                  style: TextStyle(
                    color: Colors.red, // Color de texto
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
