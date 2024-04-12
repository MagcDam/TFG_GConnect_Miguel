import 'package:flutter/material.dart';
import 'package:gconnect/gamedetailpage/gamedetailpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameList extends StatefulWidget {
  const GameList({super.key}); // Constructor de la clase GameList

  @override
  // ignore: library_private_types_in_public_api
  _GameListState createState() => _GameListState(); // Método que devuelve una instancia de _GameListState
}

class _GameListState extends State<GameList> {
  final int pageSize = 50; // Tamaño de página para la paginación
  int currentPage = 1; // Número de página actual
  List<dynamic> games = []; // Lista para almacenar los juegos

  // Método para obtener los juegos desde la API
  Future<void> fetchGames() async {
    final Uri uri = Uri.parse(
        'https://api.rawg.io/api/games?key=8b39d93d87ba4d90bc0a1db9c0aea2b9&page_size=$pageSize&page=$currentPage');

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      setState(() {
        games.addAll(json.decode(response.body)['results']); // Agrega los juegos obtenidos a la lista de juegos
        currentPage++; // Incrementa el número de página para la próxima solicitud
      });
    } else {
      throw Exception('Failed to load the games'); // Lanza una excepción si falla la carga de juegos
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGames(); // Llama al método para obtener los juegos al inicializar el estado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Most popular games'), // Título de la barra de aplicación
      ),
      body: ListView.builder(
        itemCount: games.length + 1, // Establece la cantidad de elementos en la lista, más uno para el botón de carga
        itemBuilder: (context, index) {
          if (index == games.length) { // Si el índice es igual a la longitud de la lista de juegos, muestra el botón de carga
            return ElevatedButton(
              onPressed: fetchGames, // Llama al método para obtener más juegos al presionar el botón
              child: const Text('Load more games'), // Texto del botón de carga
            );
          }
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameDetailPage(
                    gameDetails: games[index], // Pasa los detalles del juego seleccionado a la página de detalles del juego
                  ),
                ),
              );
            },
            child: ListTile(
              title: Text(games[index]['name']), // Muestra el nombre del juego en la lista
            ),
          );
        },
      ),
    );
  }
}
