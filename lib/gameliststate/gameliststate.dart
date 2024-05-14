import 'package:flutter/material.dart';
import 'package:gconnect/gamedetailpage/gamedetailpage.dart';
import 'package:gconnect/creditspage/creditspage.dart';
import 'package:gconnect/gamesearchpage/gamesearchpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameList extends StatefulWidget {
  const GameList({super.key});

  @override
  _GameListState createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  final int pageSize = 39;
  int currentPage = 1;
  List<dynamic> games = [];

  Future<void> fetchGames() async {
    final Uri uri = Uri.parse(
        'https://api.rawg.io/api/games?key=8b39d93d87ba4d90bc0a1db9c0aea2b9&page_size=$pageSize&page=$currentPage');

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      setState(() {
        games.addAll(json.decode(response.body)['results']);
        currentPage++;
      });
    } else {
      throw Exception('Failed to load the games');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Most popular games',
        style: TextStyle(color: Colors.red),),
        backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      ),
      drawer: Drawer(
        child: Container(
          color: const Color.fromARGB(255, 39, 39, 39),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 39, 39, 39),
                ),
                child: Text(
                  'GConnect Menu',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              ListTile(
                title: Text(
                  'Search',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameSearchPage()),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Credits',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => creditspage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 39, 39, 39),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: games.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameDetailPage(
                            gameDetails: games[index],
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
                          Expanded(
                            child: Image.network(
                              games[index]['background_image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            games[index]['name'],
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20), // Espacio entre la lista de juegos y el botón
            Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                onPressed: fetchGames,
                child: Text(
                  'Load more games',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
