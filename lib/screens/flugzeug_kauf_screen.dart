import 'package:flutter/material.dart';
import 'package:beyond_horizons/models/flugzeug.dart';
import 'package:beyond_horizons/models/flugzeuge/a320_200.dart'; // Beispiel-Flugzeug

class FlugzeugKaufScreen extends StatefulWidget {
  @override
  _FlugzeugKaufScreenState createState() => _FlugzeugKaufScreenState();
}

class _FlugzeugKaufScreenState extends State<FlugzeugKaufScreen> {
  final List<Flugzeug> gekaufteFlugzeuge = []; // Liste der gekauften Flugzeuge

  // Funktion zum Kauf eines neuen Flugzeugs
  void kaufeFlugzeug() {
    setState(() {
      final neuesFlugzeug = A320_200(); // Beispiel: A320-200 wird gekauft
      gekaufteFlugzeuge.add(neuesFlugzeug);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flugzeug Kauf")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: kaufeFlugzeug,
              child: Text("Flugzeug kaufen"),
            ),
            SizedBox(height: 20),
            Text("Gekaufte Flugzeuge:"),
            Expanded(
              child: ListView.builder(
                itemCount: gekaufteFlugzeuge.length,
                itemBuilder: (context, index) {
                  final flugzeug = gekaufteFlugzeuge[index];
                  return ListTile(
                    title: Text("${flugzeug.name} - ID: ${flugzeug.id}"),
                    subtitle: Text(
                      "Modell: ${flugzeug.modell}, Kapazität: ${flugzeug.sitzkapazitaet} Passagiere",
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  gekaufteFlugzeuge,
                ); // Zurück zur HomePage mit den gekauften Flugzeugen
              },
              child: Text("Zurück zur Home Page"),
            ),
          ],
        ),
      ),
    );
  }
}
