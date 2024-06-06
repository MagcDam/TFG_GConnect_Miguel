import 'package:flutter/material.dart'; // Framework de UI de Flutter
import 'package:gconnect/gamedetailpage/gamedetailpage.dart'; // Página de detalles del juego
import 'package:gconnect/creditspage/creditspage.dart'; // Página de créditos
import 'package:gconnect/gamesearchpage/gamesearchpage.dart'; // Página de búsqueda de juegos
import 'package:gconnect/profilepage/userprofilepage.dart'; // Página de perfil de usuario
import 'package:http/http.dart' as http; // Paquete para realizar solicitudes HTTP
import 'dart:convert'; // Para manejar la codificación y decodificación JSON

class GameList extends StatefulWidget {
  final String? accessToken; // Token de acceso, puede ser nulo
  final String? email; // Correo electrónico del usuario, puede ser nulo

  const GameList({super.key, required this.accessToken, required this.email});

  @override
  _GameListState createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  final int pageSize = 39; // Tamaño de página para la paginación de juegos
  int currentPage = 1; // Página actual para la paginación de juegos
  List<dynamic> games = []; // Lista de juegos
  int? userId; // ID del usuario, puede ser nulo

  // Función para obtener la lista de juegos desde la API
  Future<void> fetchGames() async {
    final Uri uri = Uri.parse(
        'https://api.rawg.io/api/games?key=8b39d93d87ba4d90bc0a1db9c0aea2b9&page_size=$pageSize&page=$currentPage');

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      setState(() {
        games.addAll(json.decode(response.body)['results']); // Añade los juegos obtenidos a la lista
        currentPage++; // Incrementa la página actual para la próxima solicitud
      });
    } else {
      throw Exception('Failed to load the games'); // Manejo de error
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGames(); // Llama a la función para obtener los juegos al iniciar el estado
    getUserData(); // Llama a la función para obtener datos del usuario al iniciar el estado
  }

  // Función para obtener datos del usuario desde la API
  Future<void> getUserData() async {
    print('buscaid'); // Mensaje para depuración
    const String apiUrl = 'https://jvnldlydmjbzrcgcjizc.supabase.co/rest/v1/users';
    String? email = widget.email; // Obtiene el email del widget
    print(email); // Imprime el email para depuración
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?email=eq.$email'),
        headers: {
          'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI',
          'Authorization': 'Bearer ${widget.accessToken}', // Añade el token de acceso en los encabezados
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Datos recibidos: $data'); // Imprime el JSON completo para ver su estructura

        setState(() {
          userId = data[0]['userId']; // Ajusta 'userId' según la estructura del JSON
        });
      } else {
        print('Error en la solicitud: ${response.statusCode}'); // Imprime el código de error
      }
    } catch (e) {
      print('Error: $e'); // Manejo de excepción
    }

    print('User ID: $userId'); // Verifica si el userId se ha establecido correctamente
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Most popular games',
          style: TextStyle(color: Colors.red), // Estilo del título
        ),
        backgroundColor: const Color.fromARGB(255, 39, 39, 39), // Color de fondo del AppBar
      ),
      drawer: Drawer(
        child: Container(
          color: const Color.fromARGB(255, 39, 39, 39), // Color de fondo del Drawer
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 39, 39, 39), // Color de fondo del DrawerHeader
                ),
                child: Center(
                  child: Image.asset(
                    'assets/logotfg.png', // Reemplaza con la ruta de tu logo
                    height: 400, // Tamaño ajustado del logo
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.search, color: Colors.red), // Icono de búsqueda
                title: const Text(
                  'Search',
                  style: TextStyle(color: Colors.red), // Estilo del texto
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameSearchPage(userId: userId)), // Navega a la página de búsqueda de juegos
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.red), // Icono de perfil
                title: const Text(
                  'Profile',
                  style: TextStyle(color: Colors.red), // Estilo del texto
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfilePage(userId: userId)), // Navega a la página de perfil de usuario
                  );
                  print('user: $userId'); // Imprime el userId para depuración
                },
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.red), // Icono de información
                title: const Text(
                  'Additional',
                  style: TextStyle(color: Colors.red), // Estilo del texto
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const creditspage()), // Navega a la página de créditos
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 39, 39, 39), // Color de fondo del cuerpo
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Número de columnas en la cuadrícula
                  crossAxisSpacing: 10, // Espaciado entre columnas
                  mainAxisSpacing: 10, // Espaciado entre filas
                ),
                itemCount: games.length, // Número de juegos en la lista
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameDetailPage(
                            gameDetails: games[index], // Detalles del juego seleccionado
                            userId: userId, // ID del usuario
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red), // Borde rojo
                        borderRadius: BorderRadius.circular(10), // Bordes redondeados
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: Image.network(
                                games[index]['background_image'], // Imagen del juego
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            games[index]['name'], // Nombre del juego
                            style: const TextStyle(color: Colors.white), // Estilo del texto
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20), // Espacio entre la lista de juegos y el botón
            Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Bordes redondeados del botón
              ),
              child: ElevatedButton(
                onPressed: fetchGames, // Llama a la función para cargar más juegos
                child: const Text(
                  'Load more games',
                  style: TextStyle(color: Colors.white), // Estilo del texto del botón
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Color de fondo del botón
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Relleno del botón
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
