import 'package:flutter/material.dart';
import 'package:beyond_horizons/services/finance_manager.dart';
import 'package:beyond_horizons/services/airline_manager.dart';
import 'package:beyond_horizons/screens/home_screen.dart';

/// Minimaler Screen für die Spielerstellung
/// Nur Airline-Name und Startkapital - zum späteren Erweitern
class GameStartScreen extends StatefulWidget {
  @override
  _GameStartScreenState createState() => _GameStartScreenState();
}

class _GameStartScreenState extends State<GameStartScreen> {
  final TextEditingController _airlineNameController = TextEditingController();
  final TextEditingController _capitalController = TextEditingController();
  int _selectedCapital = 300000000; // Standard: 300 Million USD

  @override
  void initState() {
    super.initState();
    // Standardwerte setzen
    _airlineNameController.text = "DS-Air";
    // Nur die Zahl ohne Formatierung anzeigen (300 statt 300 Mio. USD)
    _capitalController.text = "${_selectedCapital ~/ 1000000}";
  }

  @override
  void dispose() {
    _airlineNameController.dispose();
    _capitalController.dispose();
    super.dispose();
  }

  /// Startet das Spiel mit den gewählten Einstellungen
  void _startGame() {
    if (_airlineNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Bitte geben Sie einen Airline-Namen ein."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Spiel initialisieren
    FinanceManager().initializeGame(_selectedCapital);
    AirlineManager().initializeAirline(_airlineNameController.text);

    // Zum Hauptspiel wechseln
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Neue Airline erstellen"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Airline-Name
            Text(
              "Airline-Name",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _airlineNameController,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),

            // Startkapital
            Text(
              "Startkapital",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _capitalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixText: "Mio. USD",
              ),
              onChanged: (value) {
                // Parse Millionen-Betrag
                int millions = int.tryParse(value) ?? 300;
                _selectedCapital = millions * 1000000;
              },
            ),

            Spacer(),

            // Spiel starten Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startGame,
                child: Text("Spiel starten"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
