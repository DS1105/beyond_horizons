/// Main entry point for the Beyond Horizons airline simulation app
/// Sets up the Flutter application with theme and initial screen
import 'package:beyond_horizons/screens/home_screen.dart';
import 'package:beyond_horizons/screens/game_start_screen.dart';
import 'package:beyond_horizons/services/finance_manager.dart';
import 'package:flutter/material.dart';

/// Application entry point
/// Initializes and runs the Beyond Horizons app
void main() {
  runApp(MyApp());
}

/// Main application widget
/// Configures the app's theme, title, and initial screen
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beyond Horizons', // App title shown in task switcher
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(
          255,
          255,
          255,
          255,
        ), // Nur das nötigste: Scaffold weiß
      ),
      home:
          FinanceManager().isInitialized
              ? HomeScreen()
              : GameStartScreen(), // Zeige GameStart wenn nicht initialisiert
    );
  }
}
