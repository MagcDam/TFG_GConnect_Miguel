import 'package:flutter/material.dart';
import 'mainpage/mainpage.dart'; // Importamos la clase GameList que contiene la interfaz principal de nuestro juego
import 'package:supabase_flutter/supabase_flutter.dart';

const String supabaseUrl = 'https://jvnldlydmjbzrcgcjizc.supabase.com';
const String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI';

final supabaseClient = SupabaseClient(supabaseUrl, supabaseKey);

void main() {
  runApp(MyApp(supabaseClient: supabaseClient,)); // Ejecutamos nuestra aplicación Flutter
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.supabaseClient}); // Constructor de la clase MyApp

  final SupabaseClient supabaseClient;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GConnect',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: mainpage(supabaseClient: supabaseClient), // Establecemos MainPage como la página de inicio de nuestra aplicación
    );
  }
}
