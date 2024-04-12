import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameDetailPage extends StatefulWidget {
  final Map<String, dynamic> gameDetails;

  const GameDetailPage({super.key, required this.gameDetails}); // Constructor de la clase GameDetailPage

  @override
  // ignore: library_private_types_in_public_api
  _GameDetailPageState createState() => _GameDetailPageState(); // Método que devuelve una instancia de _GameDetailPageState
}

class _GameDetailPageState extends State<GameDetailPage> {
  String? description;
  String? developer;
  String? publisher;

  @override
  void initState() {
    super.initState();
    fetchDescription(); // Llama al método para obtener la descripción del juego al inicializar el estado
    fetchDeveloperAndPublisher(); // Llama al método para obtener el desarrollador y editor del juego al inicializar el estado
  }

  // Método para obtener la descripción del juego desde la API
  Future<void> fetchDescription() async {
    final int gameId = widget.gameDetails['id']; // Obtiene el ID del juego
    final Uri uri = Uri.parse(
        'https://api.rawg.io/api/games/$gameId?key=8b39d93d87ba4d90bc0a1db9c0aea2b9&language=english');

    final response = await http.get(uri); // Realiza la solicitud HTTP
    if (response.statusCode == 200) {
      const Utf8Decoder utf8decoder = Utf8Decoder(); // Decodificador UTF-8
      final decodedResponse =
          utf8decoder.convert(response.bodyBytes); // Decodifica la respuesta
      setState(() {
        description = json.decode(decodedResponse)['description_raw']; // Establece la descripción del juego
      });
    } else {
      throw Exception('Failed to load game description'); // Lanza una excepción si falla la carga de la descripción del juego
    }
  }

  // Método para obtener el desarrollador y editor del juego desde la API
  Future<void> fetchDeveloperAndPublisher() async {
    final int gameId = widget.gameDetails['id']; // Obtiene el ID del juego
    final Uri uri = Uri.parse(
        'https://api.rawg.io/api/games/$gameId?key=8b39d93d87ba4d90bc0a1db9c0aea2b9');

    final response = await http.get(uri); // Realiza la solicitud HTTP
    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      setState(() {
        // Establece el desarrollador y el editor del juego
        developer = decodedResponse['developers'] != null &&
                decodedResponse['developers'].isNotEmpty
            ? decodedResponse['developers'][0]['name']
            : 'N/A';
        publisher = decodedResponse['publishers'] != null &&
                decodedResponse['publishers'].isNotEmpty
            ? decodedResponse['publishers'][0]['name']
            : 'N/A';
      });
    } else {
      throw Exception(
          'Failed to load developer and publisher information'); // Lanza una excepción si falla la carga de la información del desarrollador y editor del juego
    }
  }

  // Método para obtener la calificación por edad del juego
  String getAgeRating(String rating) {
    switch (rating.toLowerCase()) {
      case 'mature':
        return '18+';
      case 'teen':
        return '13-17';
      case 'everyone':
        return '0-12';
      default:
        return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> platforms = [];

    if (widget.gameDetails['platforms'] != null) {
      platforms = (widget.gameDetails['platforms'] as List)
          .map<String>((platform) =>
              platform['platform']['name'].toString())
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameDetails['name']), // Título de la barra de aplicación
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Game name: ${widget.gameDetails['name']}", // Nombre del juego
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Platforms: ${platforms.isNotEmpty ? platforms.join(', ') : 'N/A'}", // Plataformas en las que está disponible el juego
              ),
              const SizedBox(height: 8),
              Text(
                "Release date: ${widget.gameDetails['released'] ?? 'N/A'}", // Fecha de lanzamiento del juego
              ),
              const SizedBox(height: 8),
              Text(
                "Description: ${description ?? 'Loading...'}", // Descripción del juego
              ),
              const SizedBox(height: 8),
              Text(
                "Developer: ${developer ?? 'Loading...'}", // Desarrollador del juego
              ),
              const SizedBox(height: 8),
              Text(
                "Publisher: ${publisher ?? 'Loading...'}", // Editor del juego
              ),
              const SizedBox(height: 8),
              Text(
                "Genre: ${widget.gameDetails['genres']?.map((genre) => genre['name'])?.join(', ') ?? 'N/A'}", // Género del juego
              ),
              const SizedBox(height: 8),
              Text(
                "Classification: ${getAgeRating(widget.gameDetails['esrb_rating']?['name'] ?? 'N/A')}", // Clasificación por edad del juego
              ),
              const SizedBox(height: 8),
              Text(
                "Metacritic Score: ${widget.gameDetails['metacritic'] ?? 'N/A'}", // Puntuación de Metacritic del juego
              ),
            ],
          ),
        ),
      ),
    );
  }
}
