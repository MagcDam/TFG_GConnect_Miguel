import 'package:flutter/material.dart';
import 'mainpage/mainpage.dart'; // Importamos la clase GameList que contiene la interfaz principal de nuestro juego

void main() {
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
      home: mainpage(), // Establecemos GameList como la página de inicio de nuestra aplicación
    );
  }
}
