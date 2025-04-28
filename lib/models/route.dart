// route.dart
import 'package:beyond_horizons/models/flughafen.dart';
import 'flugzeug.dart';

class Route {
  final Flughafen startFlughafen;
  final Flughafen zielFlughafen;
  final List<Flugzeug> flugzeuge; // Liste von zugewiesenen Flugzeugen
  int fluegeProWoche; // Flüge pro Woche
  final Map<String, double> ticketPreise;
  bool bordservice;

  Route({
    required this.startFlughafen,
    required this.zielFlughafen,
    required this.flugzeuge,
    required this.fluegeProWoche,
    required this.ticketPreise,
    required this.bordservice,
  });

  double berechneKapazitaet() {
    // Berechne die Kapazität basierend auf der Anzahl der Flugzeuge und Flüge pro Woche
    const int passagiereProFlugzeug =
        180; // Standard: 180 Passagiere pro Flugzeug

    // Sicherstellen, dass fluegeProWoche als double behandelt wird
    double fluegeProWocheDouble = fluegeProWoche.toDouble();

    // Berechnung der Kapazität
    final double kapazitaet =
        flugzeuge.length * fluegeProWocheDouble * passagiereProFlugzeug;

    return kapazitaet;
  }

  // Optionale Methode, die die Kapazität in einem menschenfreundlicheren Format anzeigt
  String getKapazitaetAnzeige() {
    final kapazitaet = berechneKapazitaet();
    return 'Kapazität: ${kapazitaet.toStringAsFixed(0)} Passagiere';
  }
}
