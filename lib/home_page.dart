
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login_page.dart';
import 'quotes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String quote = '';
  String author = '';
  bool isLoading = true;

  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchQuote();
    getToken();
  }

  // Logout function
  Future<void> logoutUser() async {
    await storage.delete(key: 'auth_token');

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  // Read the saved authentication token
  Future<void> getToken() async {
    String? token = await storage.read(key: 'auth_token');
    print('Saved Token: $token');
  }

  // Fetch motivational quote
  Future<void> fetchQuote() async {
    var url = Uri.parse('https://zenquotes.io/api/random');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        setState(() {
          quote = data[0]['q'];
          author = data[0]['a'];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Motivation'),
        actions: [
          IconButton(
            onPressed: logoutUser,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      quote,
                      style: const TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '- $author',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: fetchQuote,
                      child: const Text('New Quote'),
                    ),
                    const SizedBox(height: 15),

                    ElevatedButton(
                       onPressed: () {
                        Navigator.push(
                          context,
                         MaterialPageRoute(
                           builder: (context) => const QuotesPage(),
                         ),
                        );
                      },
                     child: const Text('Explore Motivational Quotes'),
),
                  ],
                ),
              ),
      ),
    );
  }
}
