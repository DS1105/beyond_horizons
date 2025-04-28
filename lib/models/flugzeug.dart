// lib/models/flugzeug.dart

class Flugzeug {
  static int _idCounter = 1; // Statische Variable zur ID-Verwaltung
  final int id; // Eindeutige ID für jedes Flugzeug
  final String name;
  final String modell;
  final int sitzkapazitaet;
  final int reichweite;
  final int verbrauchProStunde;

  Flugzeug({
    required this.name,
    required this.modell,
    required this.sitzkapazitaet,
    required this.reichweite,
    required this.verbrauchProStunde,
  }) : id = _idCounter++; // Jede Instanz bekommt eine eindeutige ID

  // Beispielmethoden oder Eigenschaften für Flugzeug
}
