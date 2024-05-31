import 'package:flutter/material.dart';
import 'package:gconnect/gamedetailpage/gamedetailpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfilePage extends StatefulWidget {
  final int? userId;

  const UserProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String? username;
  int favoriteCount = 0;
  List<dynamic> favoriteGames = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchFavoriteGames();
  }

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
          username = data[0]['username'];
        });
      }
    } else {
      throw Exception('Failed to load user data');
    }
  }

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
          favoriteCount = data.length;
          favoriteGames = data;
        });
      }
    } else {
      throw Exception('Failed to load favorite games');
    }
  }

  Future<Map<String, dynamic>> fetchGameDetails(int gameId) async {
    final Uri uri = Uri.parse(
        'https://api.rawg.io/api/games/$gameId?key=8b39d93d87ba4d90bc0a1db9c0aea2b9');

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      return decodedResponse;
    } else {
      throw Exception('Failed to load game details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      appBar: AppBar(
        title: const Text('User profile', style: TextStyle(color: Colors.red),
        ),
        backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username ?? 'Loading...',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Favorite games counter: $favoriteCount',
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Favorite games',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: favoriteGames.length,
                itemBuilder: (context, index) {
                  final game = favoriteGames[index];
                  final gameId = game['gameId'];
                  return FutureBuilder<Map<String, dynamic>>(
                    future: fetchGameDetails(gameId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Icon(Icons.error));
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
                                  Text(
                                    gameDetails['name'] ?? 'Nombre no disponible',
                                    style: const TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const Center(child: Text('Detalles del juego no disponibles', style: TextStyle(color: Colors.white)));
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
