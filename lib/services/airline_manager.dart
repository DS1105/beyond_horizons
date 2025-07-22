/// Singleton für die Verwaltung der Airline-Daten
/// Speichert den Airline-Namen
class AirlineManager {
  static final AirlineManager _instance = AirlineManager._internal();

  factory AirlineManager() => _instance;
  AirlineManager._internal();

  String _airlineName = "";

  String get airlineName => _airlineName;

  void initializeAirline(String name) {
    _airlineName = name.trim();
  }
}
