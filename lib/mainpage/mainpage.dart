import 'package:flutter/material.dart';
import 'package:gconnect/creditspage/creditspage.dart';
import 'package:gconnect/gameliststate/gameliststate.dart';
import 'package:gconnect/gamesearchpage/gamesearchpage.dart';

class mainpage extends StatelessWidget {
  const mainpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        title: const Text('Gconnect'),
      ),
            drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text(
                'Options',
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('Most popular games'), // Elemento del cajón para juegos mas populares
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameList(), // Navega a la página de búsqueda de juegos al hacer clic
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Search game'), // Elemento del cajón para buscar juegos
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameSearchPage(), // Navega a la página de búsqueda de juegos al hacer clic
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Credits'), // Elemento del cajón para buscar juegos
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const creditspage(), // Navega a la página de búsqueda de juegos al hacer clic
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GCONNECT',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Alpha 0.1.2',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
