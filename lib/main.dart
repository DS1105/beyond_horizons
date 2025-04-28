import 'package:beyond_horizons/screens/home_Screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beyond Horizons',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(), // Setze den HomeScreen als Startscreen
    );
  }
}
