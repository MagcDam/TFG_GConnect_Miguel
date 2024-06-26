import 'package:flutter/material.dart'; // Framework de UI de Flutter
import 'package:gconnect/gamedetailpage/gamedetailpage.dart'; // Página de detalles del juego
import 'package:http/http.dart' as http; // Paquete para realizar solicitudes HTTP
import 'dart:convert'; // Para manejar la codificación y decodificación JSON
import 'package:gconnect/changeinformationpage/changeinformationpage.dart';  // Asegúrate de importar la página correctamente

class UserProfilePage extends StatefulWidget {
  final int? userId; // ID del usuario, puede ser nulo

  const UserProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String? username; // Nombre de usuario, puede ser nulo
  int favoriteCount = 0; // Contador de juegos favoritos
  List<dynamic> favoriteGames = []; // Lista de juegos favoritos

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Llama a la función para obtener datos del usuario
    fetchFavoriteGames(); // Llama a la función para obtener juegos favoritos
  }

  // Función para obtener datos del usuario desde la API
  Future<void> fetchUserData() async {
    const String apiUrl = 'https://jvnldlydmjbzrcgcjizc.supabase.co/rest/v1/users';
    final response = await http.get(
      Uri.parse('$apiUrl?userId=eq.${widget.userId}'),
      headers: {
        'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List && data.isNotEmpty) {
        setState(() {
          username = data[0]['username']; // Actualiza el nombre de usuario
        });
      }
    } else {
      throw Exception('Failed to load user data'); // Manejo de error
    }
  }

  // Función para obtener juegos favoritos desde la API
  Future<void> fetchFavoriteGames() async {
    const String apiUrl = 'https://jvnldlydmjbzrcgcjizc.supabase.co/rest/v1/favoriteGames';
    final response = await http.get(
      Uri.parse('$apiUrl?userId=eq.${widget.userId}'),
      headers: {
        'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        setState(() {
          favoriteCount = data.length; // Actualiza el contador de favoritos
          favoriteGames = data; // Actualiza la lista de juegos favoritos
        });
      }
    } else {
      throw Exception('Failed to load favorite games'); // Manejo de error
    }
  }

  // Función para obtener detalles de un juego desde la API
  Future<Map<String, dynamic>> fetchGameDetails(int gameId) async {
    final Uri uri = Uri.parse(
        'https://api.rawg.io/api/games/$gameId?key=8b39d93d87ba4d90bc0a1db9c0aea2b9');

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      return decodedResponse; // Retorna los detalles del juego
    } else {
      throw Exception('Failed to load game details'); // Manejo de error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 39, 39), // Color de fondo
      appBar: AppBar(
        title: const Text(
          'User profile',
          style: TextStyle(color: Colors.red), // Estilo del título
        ),
        backgroundColor: const Color.fromARGB(255, 39, 39, 39), // Color del AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.red), // Icono de configuración
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeInformationPage(userId: widget.userId.toString()), // Navega a la página de cambiar información
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Muestra el nombre de usuario o "Loading..." si aún no se ha cargado
            Text(
              username ?? 'Loading...',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            // Muestra el contador de juegos favoritos
            Text(
              'Favorite games counter: $favoriteCount',
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Favorite games',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
            const SizedBox(height: 8.0),
            // Muestra la lista de juegos favoritos en una cuadrícula
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Número de columnas en la cuadrícula
                  mainAxisSpacing: 10, // Espaciado principal
                  crossAxisSpacing: 10, // Espaciado cruzado
                ),
                itemCount: favoriteGames.length,
                itemBuilder: (context, index) {
                  final game = favoriteGames[index];
                  final gameId = game['gameId'];
                  return FutureBuilder<Map<String, dynamic>>(
                    future: fetchGameDetails(gameId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator()); // Muestra un indicador de carga
                      } else if (snapshot.hasError) {
                        return const Center(child: Icon(Icons.error)); // Muestra un icono de error
                      } else {
                        final gameDetails = snapshot.data!;
                        if (gameDetails.containsKey('background_image')) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GameDetailPage(
                                    gameDetails: gameDetails,
                                    userId: widget.userId,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  // Muestra la imagen de fondo del juego
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      child: Image.network(
                                        gameDetails['background_image'] ?? '',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  // Muestra el nombre del juego
                                  Text(
                                    gameDetails['name'] ?? 'Nombre no disponible',
                                    style:
                                        const TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const Center(
                              child: Text('Detalles del juego no disponibles',
                                  style: TextStyle(color: Colors.white)));
                        }
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
