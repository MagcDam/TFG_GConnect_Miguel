import 'package:flutter/material.dart';
import 'package:gconnect/loginpage/loginpage.dart';
import 'package:gconnect/registerpage/registerpage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String supabaseUrl = 'https://jvnldlydmjbzrcgcjizc.supabase.com';
const String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bmxkbHlkbWpienJjZ2NqaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM1MjIwMzMsImV4cCI6MjAyOTA5ODAzM30.YkCP0-lpW1sWD2ZMrJuLxuctRiMjvNl4PxP1fU5CDzI';

final supabaseClient = SupabaseClient(supabaseUrl, supabaseKey);

class mainpage extends StatelessWidget {
  const mainpage({super.key, required this.supabaseClient});

  final SupabaseClient supabaseClient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gconnect'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GCONNECT',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Alpha 0.1.2',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(supabaseClient: supabaseClient),
                  ),
                );
              },
              child: Text('Get Started'),
            ),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => LoginPage(supabaseClient: supabaseClient)
                    ),
                );
              },
              child: Text(
                'Do you already have an account? Log in here!',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
