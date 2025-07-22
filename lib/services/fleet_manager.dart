import 'package:beyond_horizons/models/aircraft.dart';

/// Manager für die eigene Flugzeugflotte
/// Verwaltet alle gekauften Flugzeuge der Airline
class FleetManager {
  static final FleetManager _instance = FleetManager._internal();
  factory FleetManager() => _instance;
  FleetManager._internal();

  // Liste aller gekauften Flugzeuge
  final List<Aircraft> _ownedAircraft = [];

  /// Getter für alle eigenen Flugzeuge
  List<Aircraft> get ownedAircraft => List.unmodifiable(_ownedAircraft);

  /// Anzahl der eigenen Flugzeuge
  int get aircraftCount => _ownedAircraft.length;

  /// Fügt ein neues Flugzeug zur Flotte hinzu
  void addAircraft(Aircraft aircraft) {
    _ownedAircraft.add(aircraft);
  }

  /// Entfernt ein Flugzeug aus der Flotte (z.B. beim Verkauf)
  bool removeAircraft(int aircraftId) {
    final index = _ownedAircraft.indexWhere(
      (aircraft) => aircraft.id == aircraftId,
    );
    if (index != -1) {
      _ownedAircraft.removeAt(index);
      return true;
    }
    return false;
  }

  /// Gibt alle verfügbaren Flugzeuge für eine Route zurück
  /// (nicht bereits einer Route zugewiesen und ausreichende Reichweite)
  List<Aircraft> getAvailableAircraftForRoute(int requiredRange) {
    return _ownedAircraft
        .where(
          (aircraft) =>
              !aircraft.isAssignedToRoute && aircraft.range >= requiredRange,
        )
        .toList();
  }

  /// Setzt die Flotte zurück (für Spielneustart)
  void resetFleet() {
    _ownedAircraft.clear();
  }

  /// Findet ein Flugzeug anhand der ID
  Aircraft? getAircraftById(int id) {
    try {
      return _ownedAircraft.firstWhere((aircraft) => aircraft.id == id);
    } catch (e) {
      return null;
    }
  }
}
