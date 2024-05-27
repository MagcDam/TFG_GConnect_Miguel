import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../gamedetailpage/gamedetailpage.dart';
import '../searchcounter/searchcounter.dart'; // Importa la clase SearchCounter

class GameSearchPage extends StatefulWidget {
  final int? userId;
  const GameSearchPage({super.key, required this.userId}); // Constructor de la clase GameSearchPage

  @override
  // ignore: library_private_types_in_public_api
  _GameSearchPageState createState() => _GameSearchPageState(); // Método que devuelve una instancia de _GameSearchPageState
}

class _GameSearchPageState extends State<GameSearchPage> {
  List<dynamic> searchResults = []; // Lista para almacenar los resultados de búsqueda
  final SearchCounter _counter = SearchCounter(); // Instancia de SearchCounter para el contador de búsquedas

  // Método para buscar juegos en la API
  void searchGames(String searchText) async {
    final Uri uri = Uri.parse(
        'https://api.rawg.io/api/games?key=8b39d93d87ba4d90bc0a1db9c0aea2b9&search=$searchText');

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      setState(() {
        searchResults = json.decode(response.body)['results']; // Almacena los resultados de la búsqueda en la lista
      });
    } else {
      throw Exception('Failed to search games'); // Lanza una excepción en caso de error en la búsqueda
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 39, 39), // Fondo de la página negro
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 39, 39, 39), // Color de fondo del AppBar igual que el de la página
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Search game',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red), // Borde del cuadro de búsqueda de color rojo
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red), // Borde del cuadro de búsqueda de color rojo
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red), // Borde del cuadro de búsqueda de color rojo
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelStyle: const TextStyle(color: Colors.white), // Texto del cuadro de búsqueda de color blanco
                    prefixIconColor: Colors.white, // Icono de búsqueda de color blanco
                  ),
                  style: const TextStyle(color: Colors.white), // Texto ingresado de color blanco
                  onChanged: (value) {
                    searchGames(value); // Llama al método de búsqueda cuando cambia el texto en el campo de búsqueda
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Número de columnas
            crossAxisSpacing: 10, // Espaciado horizontal entre columnas
            mainAxisSpacing: 10, // Espaciado vertical entre filas
          ),
          itemCount: searchResults.length, // Establece la cantidad de elementos en la lista según la longitud de los resultados de búsqueda
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                await _counter.incrementSearchCount(); // Incrementa el contador de búsquedas antes de navegar a los detalles del juego
                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameDetailPage(
                      gameDetails: searchResults[index],
                      userId: widget.userId, // Pasa los detalles del juego seleccionado a la página de detalles del juego
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red), // Borde rojo
                  borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ), // Bordes redondeados en la parte superior de la imagen
                        child: Image.network(
                          searchResults[index]['background_image'] ?? '', // Imagen del juego
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        searchResults[index]['name'], // Nombre del juego
                        style: const TextStyle(color: Colors.white), // Texto de color blanco
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
