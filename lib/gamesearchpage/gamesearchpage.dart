import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../gamedetailpage/gamedetailpage.dart';
import '../searchcounter/searchcounter.dart'; // Importa la clase SearchCounter

class GameSearchPage extends StatefulWidget {
  const GameSearchPage({super.key}); // Constructor de la clase GameSearchPage

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
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search game',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    searchGames(value); // Llama al método de búsqueda cuando cambia el texto en el campo de búsqueda
                  },
                ),
              ),
            ),
            FutureBuilder<int>(
              future: _counter.getSearchCount(), // Obtiene el contador de búsquedas futuras
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Muestra un indicador de carga si el futuro aún está esperando
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Muestra un mensaje de error si ocurre un error al obtener el contador
                } else {
                  return Text('Searchs: ${snapshot.data}'); // Muestra el contador de búsquedas si se obtiene correctamente
                }
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
                          gameDetails: searchResults[index], // Pasa los detalles del juego seleccionado a la página de detalles del juego
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(searchResults[index]['name']), // Muestra el nombre del juego en la lista
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
