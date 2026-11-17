
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Registration API function
  Future<void> registerUser() async {

    String email = emailController.text;
    String password = passwordController.text;

    var url = Uri.parse('https://reqres.in/api/register');

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

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful!'),
          ),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration failed!'),
          ),
        );
      }

    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: registerUser,
              child: const Text('Create Account'),
            ),
          ],
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
