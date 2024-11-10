import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isRegisterMode = false; // kalau true, berarti lagi di mode register

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // kalau udh login, langsung ke Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    }
  }

  Future<void> _login() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    final savedPassword = prefs.getString('password');

    if (savedUsername == _usernameController.text &&
        savedPassword == _passwordController.text) {
      // kalau username dan password sesuai, simpan status login
      prefs.setBool('isLoggedIn', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      // pesan error kalau username atau password salah
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid username or password')),
      );
    }
  }

  Future<void> _register() async {
    final prefs = await SharedPreferences.getInstance();

    // Simpan username, password, dan status login
    prefs.setString('username', _usernameController.text);
    prefs.setString('password', _passwordController.text);
    prefs.setBool('isLoggedIn', true);

    // Pindah ke Dashboard setelah register
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // cek apakah user udah login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_isRegisterMode) {
                    _register();
                  } else {
                    _login();
                  }
                },
                child: Text(_isRegisterMode ? 'Register' : 'Login'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // bombol untuk atur mau register atau login
                  setState(() {
                    _isRegisterMode = !_isRegisterMode;
                  });
                },
                child: Text(
                  _isRegisterMode
                      ? 'Already have an account? Login'
                      : 'Create a new account',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
