import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameDetailPage extends StatefulWidget {
  final Map<String, dynamic> gameDetails;

  const GameDetailPage({super.key, required this.gameDetails});

  @override
  // ignore: library_private_types_in_public_api
  _GameDetailPageState createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  String? description;
  String? developer;
  String? publisher;
  bool isFavorite = false;
  int? userId;

  @override
  void initState() {
    super.initState();
    getUserData();
    checkFavouriteStatus();
    fetchDescription();
    fetchDeveloperAndPublisher();
  }

  Future<void> fetchDescription() async {
    final int gameId = widget.gameDetails['id'];
    final Uri uri = Uri.parse(
        'https://api.rawg.io/api/games/$gameId?key=8b39d93d87ba4d90bc0a1db9c0aea2b9&language=english');

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      const Utf8Decoder utf8decoder = Utf8Decoder();
      final decodedResponse = utf8decoder.convert(response.bodyBytes);
      setState(() {
        description = json.decode(decodedResponse)['description_raw'];
      });
    } else {
      throw Exception('Failed to load game description');
    }
  }

  Future<void> fetchDeveloperAndPublisher() async {
    final int gameId = widget.gameDetails['id'];
    final Uri uri = Uri.parse(
        'https://api.rawg.io/api/games/$gameId?key=8b39d93d87ba4d90bc0a1db9c0aea2b9');

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      setState(() {
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
      throw Exception('Failed to load developer and publisher information');
    }
  }

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

  Future<void> getUserData() async {
    const String apiUrl = 'https://jvnldlydmjbzrcgcjizc.supabase.co/rest/v1/users?select=userId'; 
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          setState(() {
            userId = data[0]['userId'];
          });
        } else {
          print('No users found or data format is not a list');
        }
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> checkFavouriteStatus() async {
    if (userId != null) {
      final response = await http.get(
        Uri.parse(
            'https://jvnldlydmjbzrcgcjizc.supabase.co/rest/v1/favoriteGames?gameId=eq.${widget.gameDetails['id']}&userId=eq.$userId'),
        headers: {
          'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData.length > 0) {
          setState(() {
            isFavorite = true;
          });
        }
      }
    }
  }

void toggleFavourite() async {
  const supabaseUrl = 'https://jvnldlydmjbzrcgcjizc.supabase.co';
  const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI';

  if (userId != null) {
    setState(() {
      isFavorite = !isFavorite;
    });

    final gameId = widget.gameDetails['id'];

    try {
      final Uri postFavoriteUri = Uri.parse('$supabaseUrl/rest/v1/favoriteGames');
      final Uri deleteFavoriteUri = Uri.parse('$supabaseUrl/rest/v1/favoriteGames?gameId=eq.$gameId&userId=eq.$userId');

      http.Response response;

      if (isFavorite) {
        // Insert into favoriteGames table
        response = await http.post(
          postFavoriteUri,
          headers: {
            'apikey': supabaseKey,
            'Content-Type': 'application/json',
          },
          body: json.encode({'gameId': gameId, 'userId': userId}),
        );
      } else {
        // Delete from favoriteGames table
        response = await http.delete(
          deleteFavoriteUri,
          headers: {
            'apikey': supabaseKey,
            'Content-Type': 'application/json',
          },
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackBar(
            'Game ${isFavorite ? 'added to' : 'removed from'} favorites');
      } else {
        print('Error: ${response.statusCode}');
        print('Error response: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
      _showSnackBar('An error occurred');
    }
  }
}





  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$title ',
              style: const TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> platforms = [];

    if (widget.gameDetails['platforms'] != null) {
      platforms = (widget.gameDetails['platforms'] as List)
          .map<String>((platform) => platform['platform']['name'].toString())
          .toList();
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 39, 39, 39),
        title: Text(widget.gameDetails['name'],
            style: const TextStyle(color: Colors.red)),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              toggleFavourite();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isFavorite ? 'Added to favorites' : 'Remove form favorites'),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.network(
                    widget.gameDetails['background_image'] ?? '',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              _buildDetailRow("Game name:", widget.gameDetails['name']),
              _buildDetailRow(
                  "Platforms:",
                  platforms.isNotEmpty
                      ? platforms.join(', ')
                      : 'N/A'),
              _buildDetailRow(
                  "Release date:", widget.gameDetails['released'] ?? 'N/A'),
              _buildDetailRow(
                  "Description:", description ?? 'Loading...'),
              _buildDetailRow(
                  "Developer:", developer ?? 'Loading...'),
              _buildDetailRow(
                  "Publisher:", publisher ?? 'Loading...'),
              _buildDetailRow(
                  "Genre:",
                  widget.gameDetails['genres']
                          ?.map((genre) => genre['name'])
                          ?.join(', ') ??
                      'N/A'),
              _buildDetailRow(
                  "Classification:",
                  getAgeRating(widget.gameDetails['esrb_rating']?['name'] ??
                      'N/A')),
              _buildDetailRow(
                  "Metacritic Score:",
                  widget.gameDetails['metacritic']?.toString() ??
                      'N/A'),
            ],
          ),
        ),
      ),
    );
  }
}
