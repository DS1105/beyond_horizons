import 'package:beyond_horizons/models/flughafen.dart';
import 'package:beyond_horizons/models/flugzeug.dart'; // Importiere die Flugzeug-Klasse

class Airline {
  final String name; // Der Name der Airline
  final Flughafen flughafen; // Der Flughafen, von dem die Airline operiert

  // Konstruktor der Airline-Klasse
  Airline({
    required this.name, // Der Name der Airline wird bei der Erstellung gesetzt
    required this.flughafen, // Der Flughafen, an dem die Airline basiert
  });

  // Methode zum Erstellen einer neuen Route (diese könnte später verwendet werden)
  void erstelleRoute(
    Flughafen startFlughafen,
    Flughafen zielFlughafen,
    int fluegeProWoche, // Flüge pro Woche
    String flugzeugModel, // Flugzeugmodell
    Map<String, double> ticketPreise, // Ticketpreise für verschiedene Klassen
    bool bordservice, // Bordservice Ja/Nein
  ) {
    // Flugzeuge werden hier nicht direkt zugewiesen, sondern in einer Route übergeben
    // Route erstellen - hier könnte eine Logik zum Erstellen der Route folgen
    print(
      'Route von ${startFlughafen.name} nach ${zielFlughafen.name} mit Flugzeugmodell $flugzeugModel erstellt!',
    );
  }
}
