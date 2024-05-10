import 'package:flutter/material.dart';
import 'mainpage/mainpage.dart'; // Importamos la clase GameList que contiene la interfaz principal de nuestro juego
import 'package:supabase_flutter/supabase_flutter.dart';

// URL y clave de autenticación de Supabase
const String supabaseUrl = 'https://jvnldlydmjbzrcgcjizc.supabase.com';
const String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI';

// Cliente de Supabase
final supabaseClient = SupabaseClient(supabaseUrl, supabaseKey);

void main() {
  // Iniciamos la aplicación Flutter
  runApp(MyApp(supabaseClient: supabaseClient,));
}

class MyApp extends StatelessWidget {
  // Constructor de la clase MyApp
  const MyApp({Key? key, required this.supabaseClient}) : super(key: key);

  // Cliente de Supabase
  final SupabaseClient supabaseClient;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Configuraciones de la aplicación Flutter
      debugShowCheckedModeBanner: false, // Oculta la cinta de depuración
      title: 'GConnect', // Título de la aplicación
      theme: ThemeData(
        // Tema de la aplicación
        primarySwatch: Colors.red, // Color primario
      ),
      home: mainpage(supabaseClient: supabaseClient), // Establece MainPage como la página de inicio de nuestra aplicación
    );
  }
}
