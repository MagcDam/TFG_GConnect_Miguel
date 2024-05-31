import 'package:flutter/material.dart';

class creditspage extends StatelessWidget {
  const creditspage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Additional', style: TextStyle(color: Colors.red)),
        backgroundColor: const Color.fromARGB(255, 39, 39, 39), // Cambio de color de fondo de la AppBar
      ),
      body: Container(
        color: const Color.fromARGB(255, 39, 39, 39), // Fondo negro para el cuerpo
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Application developed by Miguel Angel.',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red, // Color de letra rojo
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Gconnect, all rights reserved, this application is just a beta version.',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[300], // Color de letra gris claro
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
