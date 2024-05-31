import 'package:flutter/material.dart';
import 'package:gconnect/profilepage/userprofilepage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../gamedetailpage/gamedetailpage.dart';

class GameSearchPage extends StatefulWidget {
  final int? userId;
  const GameSearchPage({super.key, required this.userId});

  @override
  _GameSearchPageState createState() => _GameSearchPageState();
}

class _GameSearchPageState extends State<GameSearchPage> {
  List<dynamic> searchResults = [];

  void searchGames(String searchText) async {
    final Uri uri = Uri.parse(
        'https://api.rawg.io/api/games?key=8b39d93d87ba4d90bc0a1db9c0aea2b9&search=$searchText');

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final games = json.decode(response.body)['results'];
      setState(() {
        searchResults.addAll(games.map((game) => {'type': 'game', 'data': game}).toList());
      });
    } else {
      throw Exception('Failed to search games');
    }
  }

  void searchUsers(String searchText) async {
    final response = await http.get(
      Uri.parse('https://jvnldlydmjbzrcgcjizc.supabase.co/rest/v1/users?username=eq.$searchText'),
      headers: {
        'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final users = json.decode(response.body);
      setState(() {
        searchResults.addAll(users.map((user) => {'type': 'user', 'data': user}).toList());
      });
    } else {
      throw Exception('Failed to search users');
    }
  }

  void performSearch(String searchText) {
    setState(() {
      searchResults.clear();
    });
    searchGames(searchText);
    searchUsers(searchText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 39, 39, 39),
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Search game or user',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelStyle: const TextStyle(color: Colors.white),
                    prefixIconColor: Colors.white,
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    performSearch(value);
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
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final result = searchResults[index];
            if (result['type'] == 'game') {
              final game = result['data'];
              return InkWell(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameDetailPage(
                        gameDetails: game,
                        userId: widget.userId,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                          child: Image.network(
                            game['background_image'] ?? '',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          game['name'],
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (result['type'] == 'user') {
              final user = result['data'];
              return InkWell(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfilePage(
                        userId: user['userId'],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person, color: Colors.white, size: 50),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          user['username'],
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
