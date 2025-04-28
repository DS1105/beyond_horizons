import 'package:beyond_horizons/models/flugzeug.dart';
import 'package:beyond_horizons/models/route.dart' as custom_route;
import 'package:beyond_horizons/models/flughafen.dart';
import 'package:beyond_horizons/models/airline.dart';
import 'package:flutter/material.dart';

class RouteErstellenScreen extends StatefulWidget {
  final Flughafen startFlughafen;
  final Flughafen zielFlughafen;
  final Airline airline;
  final List<Flugzeug> gekaufteFlugzeuge; // Liste der gekauften Flugzeuge

  RouteErstellenScreen({
    required this.startFlughafen,
    required this.zielFlughafen,
    required this.airline,
    required this.gekaufteFlugzeuge, // Die gekauften Flugzeuge werden übergeben
  });

  @override
  _RouteErstellenScreenState createState() => _RouteErstellenScreenState();
}

class _RouteErstellenScreenState extends State<RouteErstellenScreen> {
  final List<Flugzeug> flugzeugeAssigned = []; // Zuordnung von Flugzeugen
  final Map<String, double> _ticketPreise = {
    'Economy': 100.0,
    'Business': 250.0,
  };

  bool _bordservice = false;
  int _fluegeProWoche = 0;

  void updateKapazitaet() {
    // Kapazität neu berechnen und anzeigen
    double neueKapazitaet =
        custom_route.Route(
          startFlughafen: widget.startFlughafen,
          zielFlughafen: widget.zielFlughafen,
          flugzeuge: flugzeugeAssigned,
          fluegeProWoche: _fluegeProWoche,
          ticketPreise: _ticketPreise,
          bordservice: _bordservice,
        ).berechneKapazitaet();

    print("Aktuelle Kapazität: $neueKapazitaet");
  }

  @override
  Widget build(BuildContext context) {
    print(
      'Gekaufte Flugzeuge: ${widget.gekaufteFlugzeuge.length}',
    ); // Debugging-Ausgabe
    print(
      'Gekaufte Flugzeuge im RouteErstellenScreen: ${widget.gekaufteFlugzeuge}',
    );

    return Scaffold(
      appBar: AppBar(title: Text("Route Erstellen")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Start Flughafen: ${widget.startFlughafen.name}"),
            Text("Ziel Flughafen: ${widget.zielFlughafen.name}"),
            SizedBox(height: 20),
            Text("Flüge pro Woche"),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _fluegeProWoche = int.tryParse(value) ?? 0;
                  updateKapazitaet();
                });
              },
            ),
            SizedBox(height: 20),
            Text("Ticketpreise"),
            TextField(
              decoration: InputDecoration(labelText: "Economy Preis"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _ticketPreise['Economy'] = double.tryParse(value) ?? 100.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Business Preis"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _ticketPreise['Business'] = double.tryParse(value) ?? 250.0;
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text("Bordservice: "),
                Switch(
                  value: _bordservice,
                  onChanged: (value) {
                    setState(() {
                      _bordservice = value;
                    });
                  },
                ),
                Text(_bordservice ? "Ja" : "Nein"),
              ],
            ),
            SizedBox(height: 20),
            // Verfügbare Flugzeuge anzeigen und Hinzufügen/Entfernen ermöglichen
            Text("Verfügbare Flugzeuge:"),
            widget.gekaufteFlugzeuge.isEmpty
                ? Text(
                  "Keine Flugzeuge verfügbar.",
                ) // Wenn keine Flugzeuge vorhanden sind
                : Expanded(
                  child: ListView.builder(
                    itemCount: widget.gekaufteFlugzeuge.length,
                    itemBuilder: (context, index) {
                      final flugzeug = widget.gekaufteFlugzeuge[index];
                      return ListTile(
                        title: Text(flugzeug.modell),
                        trailing: IconButton(
                          icon: Icon(
                            flugzeugeAssigned.contains(flugzeug)
                                ? Icons.remove
                                : Icons.add,
                          ),
                          onPressed: () {
                            setState(() {
                              if (flugzeugeAssigned.contains(flugzeug)) {
                                flugzeugeAssigned.remove(flugzeug);
                              } else {
                                flugzeugeAssigned.add(flugzeug);
                              }
                              updateKapazitaet();
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
            SizedBox(height: 20),
            Text("Zugewiesene Flugzeuge:"),
            Expanded(
              child: ListView.builder(
                itemCount: flugzeugeAssigned.length,
                itemBuilder: (context, index) {
                  final flugzeug = flugzeugeAssigned[index];
                  return ListTile(
                    title: Text(flugzeug.modell),
                    trailing: IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          flugzeugeAssigned.removeAt(index);
                          updateKapazitaet();
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (flugzeugeAssigned.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Mindestens ein Flugzeug muss zugewiesen werden",
                      ),
                    ),
                  );
                } else {
                  final route = custom_route.Route(
                    startFlughafen: widget.startFlughafen,
                    zielFlughafen: widget.zielFlughafen,
                    flugzeuge: flugzeugeAssigned,
                    fluegeProWoche: _fluegeProWoche,
                    ticketPreise: _ticketPreise,
                    bordservice: _bordservice,
                  );

                  // Flughäfen Kapazität abziehen
                  setState(() {
                    widget.startFlughafen.aktuelleSlotNutzung +=
                        route.berechneKapazitaet().toInt();
                    widget.zielFlughafen.aktuelleSlotNutzung +=
                        route.berechneKapazitaet().toInt();
                  });

                  Navigator.pop(context, route); // Die Route zurückgeben
                }
              },
              child: Text("Route erstellen"),
            ),
          ],
        ),
      ),
    );
  }
}
