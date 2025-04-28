import 'package:beyond_horizons/models/flughafen.dart';
import 'package:beyond_horizons/models/airline.dart';
import 'package:beyond_horizons/models/flugzeug.dart';
import 'package:beyond_horizons/screens/route_erstellen_screen.dart';
import 'package:beyond_horizons/screens/flugzeug_kauf_screen.dart'; // Importiere den Flugzeug Kauf Screen
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Flughafen> flughafenListe = [
    Flughafen(
      name: "Flughafen Frankfurt",
      land: "Deutschland",
      city: "Frankfurt",
      slotKapazitaet: 500000,
      aktuelleSlotNutzung: 300000,
      terminalKapazitaet: 200000,
      aktuelleTerminalNutzung: 150000,
      maxKapazitaet: 800000,
    ),
    Flughafen(
      name: "Flughafen München",
      land: "Deutschland",
      city: "München",
      slotKapazitaet: 400000,
      aktuelleSlotNutzung: 150000,
      terminalKapazitaet: 100000,
      aktuelleTerminalNutzung: 50000,
      maxKapazitaet: 600000,
    ),
    Flughafen(
      name: "Flughafen Berlin",
      land: "Deutschland",
      city: "Berlin",
      slotKapazitaet: 300000,
      aktuelleSlotNutzung: 200000,
      terminalKapazitaet: 150000,
      aktuelleTerminalNutzung: 120000,
      maxKapazitaet: 500000,
    ),
  ];

  List<Flugzeug> gekaufteFlugzeuge = []; // Liste der gekauften Flugzeuge

  void updateKapazitaet(Flughafen flughafen, int verbrauchteSlots) {
    setState(() {
      flughafen.aktuelleSlotNutzung += verbrauchteSlots;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Screen")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Verfügbare Flughäfen:", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: flughafenListe.length,
                itemBuilder: (context, index) {
                  final flughafen = flughafenListe[index];
                  return ListTile(
                    title: Text(flughafen.name),
                    subtitle: Text(
                      "Stadt: ${flughafen.city}\nLand: ${flughafen.land}\n"
                      "Verfügbare Slots: ${flughafen.slotKapazitaet - flughafen.aktuelleSlotNutzung} / ${flughafen.slotKapazitaet} Slots\n"
                      "Verfügbare Terminal Kapazität: ${flughafen.terminalKapazitaet - flughafen.aktuelleTerminalNutzung} / ${flughafen.terminalKapazitaet} Terminal Kapazität",
                    ),
                    onTap: () async {
                      final route = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => RouteErstellenScreen(
                                startFlughafen: flughafen,
                                zielFlughafen: flughafenListe.firstWhere(
                                  (f) => f != flughafen,
                                ),
                                airline: Airline(
                                  name: 'Air Berlin',
                                  flughafen: flughafen,
                                ),
                                gekaufteFlugzeuge:
                                    gekaufteFlugzeuge, // Gekaufte Flugzeuge übergeben
                              ),
                        ),
                      );
                      if (route != null) {
                        // Update the capacity after creating the route
                        updateKapazitaet(flughafen, route.fluegeProWoche * 180);
                      }
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => RouteErstellenScreen(
                          startFlughafen: flughafenListe.first,
                          zielFlughafen: flughafenListe.last,
                          airline: Airline(
                            name: 'Air Berlin',
                            flughafen: flughafenListe.first,
                          ),
                          gekaufteFlugzeuge:
                              gekaufteFlugzeuge, // Gekaufte Flugzeuge übergeben
                        ),
                  ),
                );
              },
              child: Text("Route Erstellen"),
            ),
            ElevatedButton(
              onPressed: () async {
                final gekauftesFlugzeug = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlugzeugKaufScreen()),
                );
                if (gekauftesFlugzeug != null) {
                  setState(() {
                    gekaufteFlugzeuge.addAll(
                      gekauftesFlugzeug,
                    ); // Flugzeuge zur Liste hinzufügen
                  });
                }
              },
              child: Text("Flugzeug Kaufen"),
            ),

            ElevatedButton(
              onPressed: () {
                // Hier kannst du eine Route anzeigen lassen, wenn gewünscht
              },
              child: Text("Routen Ansehen"),
            ),
          ],
        ),
      ),
    );
  }
}
