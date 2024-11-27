import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _clearInputFields();
  }

  void _clearInputFields() {
    _usernameController.clear();
    _passwordController.clear();
  }

  Future<bool> _checkAccount(String username, String password) async {
    try {
      const String apiUrl = 'http://localhost:3000/users';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);

        final user = users.firstWhere(
          (user) =>
              user['username'] == username && user['password'] == password,
          orElse: () => null,
        );

        if (user != null) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('loggedInUsername', user['username']);
          await prefs.setString('firstName', user['firstName']);
          await prefs.setString('lastName', user['lastName']);
          await prefs.setString('gender', user['gender']);
          await prefs.setString('phone', user['phone']);
          await prefs.setString('address', user['address']);
          return true;
        }
      } else {
        throw Exception('Failed to load users from API');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Marvel Movies', style: TextStyle(fontSize: 32)),
              const SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(hintText: 'Username'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(hintText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final username = _usernameController.text.trim();
                      final password = _passwordController.text.trim();

                      if (username.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Username and Password cannot be empty!'),
                          ),
                        );
                        _clearInputFields();
                        return;
                      }

                      if (await _checkAccount(username, password)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Welcome, $username!'),
                          ),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        ).then((_) => _clearInputFields());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invalid username or password!'),
                          ),
                        );
                        _clearInputFields();
                      }
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
