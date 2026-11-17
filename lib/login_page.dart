
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'signup_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final storage = FlutterSecureStorage();

  // Controllers to read user input
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Login API function
  Future<void> loginUser() async {
    String email = emailController.text;
    String password = passwordController.text;

    var url = Uri.parse('https://reqres.in/api/login');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'reqres-free-v1',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String token = data['token'];

        await storage.write(
          key: 'auth_token',
          value: token,
        );

        print('Token saved successfully');

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        print('Login failed');
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
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Login button
              ElevatedButton(
                onPressed: loginUser,
                child: const Text('Login'),
              ),

              // Sign Up navigation button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ),
                  );
                },
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

