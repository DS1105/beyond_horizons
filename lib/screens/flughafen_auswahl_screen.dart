import 'package:beyond_horizons/models/flughafen.dart';
import 'package:flutter/material.dart';

class FlughafenauswahlScreen extends StatelessWidget {
  final List<Flughafen> flughafenListe = [
    Flughafen(
      name: "Flughafen Frankfurt",
      land: "Deutschland",
      city: "Frankfurt",
      slotKapazitaet: 500000, // Kapazität für Slots
      aktuelleSlotNutzung: 300000,
      terminalKapazitaet: 200000, // Kapazität des Terminals
      aktuelleTerminalNutzung: 200000,
      maxKapazitaet: 800000,
    ),
    Flughafen(
      name: "Flughafen München",
      land: "Deutschland",
      city: "München",
      slotKapazitaet: 400000,
      aktuelleSlotNutzung: 150000,
      terminalKapazitaet: 150000,
      aktuelleTerminalNutzung: 100000,
      maxKapazitaet: 600000,
    ),
    Flughafen(
      name: "Flughafen Berlin",
      land: "Deutschland",
      city: "Berlin",
      slotKapazitaet: 300000,
      aktuelleSlotNutzung: 200000,
      terminalKapazitaet: 100000,
      aktuelleTerminalNutzung: 150000,
      maxKapazitaet: 500000,
    ),
    // Weitere Flughäfen hier hinzufügen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flughafenauswahl")),
      body: ListView.builder(
        itemCount: flughafenListe.length,
        itemBuilder: (context, index) {
          final flughafen = flughafenListe[index];
          return ListTile(
            title: Text(flughafen.name),
            subtitle: Text(
              "Stadt: ${flughafen.city}\nLand: ${flughafen.land}\n"
              "Aktuelle Slots Nutzung: ${flughafen.aktuelleSlotNutzung} / ${flughafen.slotKapazitaet} Slots\n"
              "Aktuelle Terminal Nutzung: ${flughafen.aktuelleTerminalNutzung} / ${flughafen.terminalKapazitaet} Terminal Kapazität",
            ),
            onTap: () {
              // Hier kannst du Aktionen ausführen, wenn ein Flughafen ausgewählt wird
              print("Flughafen ausgewählt: ${flughafen.name}");
            },
          );
        },
      ),
    );
  }
}
