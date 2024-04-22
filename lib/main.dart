import 'package:flutter/material.dart';
import 'mainpage/mainpage.dart'; // Importamos la clase GameList que contiene la interfaz principal de nuestro juego
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
    Supabase.initialize(
    url: 'https://jvnldlydmjbzrcgcjizc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI',
    );
  runApp(const MyApp()); // Ejecutamos nuestra aplicación Flutter
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor de la clase MyApp

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GConnect',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const mainpage(), // Establecemos MainPage como la página de inicio de nuestra aplicación
    );
  }
}
