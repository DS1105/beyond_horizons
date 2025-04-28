import 'package:beyond_horizons/models/flughafen.dart';
import 'package:flutter/material.dart';

class FlughafendetailScreen extends StatelessWidget {
  final Flughafen flughafen;

  FlughafendetailScreen({required this.flughafen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${flughafen.name} Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Flughafen: ${flughafen.name}",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Land: ${flughafen.land}"),
            Text("Stadt: ${flughafen.city}"),
            SizedBox(height: 20),
            Text("Slots Kapazität: ${flughafen.slotKapazitaet} Slots"),
            Text(
              "Aktuelle Slots Nutzung: ${flughafen.aktuelleSlotNutzung} Slots",
            ),
            SizedBox(height: 20),
            Text(
              "Terminal Kapazität: ${flughafen.terminalKapazitaet} Terminals",
            ),
            Text(
              "Aktuelle Terminal Nutzung: ${flughafen.aktuelleTerminalNutzung} Terminals",
            ),
            SizedBox(height: 20),
            // Anzeigen der gesamten Kapazität
            Text("Gesamtkapazität: ${flughafen.kapazitaet} (Slots + Terminal)"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Ausbau Logik
                print('Kapazität ausbauen');
                flughafen.ausbauen('Passagierterminal');
              },
              child: Text('Flughafen Ausbau'),
            ),
          ],
        ),
      ),
    );
  }
}
