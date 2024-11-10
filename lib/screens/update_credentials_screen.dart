import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateCredentialsScreen extends StatefulWidget {
  const UpdateCredentialsScreen({super.key});

  @override
  State<UpdateCredentialsScreen> createState() =>
      _UpdateCredentialsScreenState();
}

class _UpdateCredentialsScreenState extends State<UpdateCredentialsScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    _usernameController.text = prefs.getString('username') ?? '';
    _passwordController.text = prefs.getString('password') ?? '';
  }

  Future<void> _updateCredentials() async {
    final prefs = await SharedPreferences.getInstance();

    // Update username dan password
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('password', _passwordController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Credentials updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Credentials"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'New Username',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'New Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateCredentials,
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
