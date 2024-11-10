import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() => runApp(WarungAjibApp());

class WarungAjibApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warung Ajib',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
    );
  }
}
