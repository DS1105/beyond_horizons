import 'package:beyond_horizons/models/airport.dart';
import 'package:beyond_horizons/models/aircraft.dart';

/// Simple route model for the route creation process
/// Used both for temporary route creation and persistent saved routes
class Route {
  static int _idCounter = 1; // Static counter for generating unique IDs

  final int? id; // null during creation, assigned when saved
  Airport? startAirport; // Departure airport
  Airport? endAirport; // Destination airport
  Aircraft?
  selectedAircraft; // Primary aircraft for this route (backward compatibility)
  List<Aircraft> aircraft = []; // All aircraft assigned to this route
  int? flightsPerWeek; // Number of flights per week
  bool? freeFood; // Whether free food is provided

  /// Constructor for temporary route during creation process
  /// All fields are null initially and filled step by step
  Route._temp() : id = null;

  /// Constructor for persistent route (after creation is complete)
  /// Assigns a unique ID and copies data from temporary route
  Route._persistent({
    required this.startAirport,
    required this.endAirport,
    required this.selectedAircraft,
    required List<Aircraft> aircraftList,
    required this.flightsPerWeek,
    required this.freeFood,
  }) : id = _idCounter++ {
    // Add primary aircraft to list if not already there
    if (selectedAircraft != null && !aircraftList.contains(selectedAircraft)) {
      aircraft.add(selectedAircraft!);
    }
    // Add all other aircraft
    for (var plane in aircraftList) {
      if (!aircraft.contains(plane)) {
        aircraft.add(plane);
      }
    }
  }

  /// Factory constructor to create new temporary route
  factory Route.createNew() => Route._temp();

  /// Factory constructor to create persistent route from temporary route
  factory Route.fromTemporary(Route tempRoute) {
    return Route._persistent(
      startAirport: tempRoute.startAirport!,
      endAirport: tempRoute.endAirport!,
      selectedAircraft: tempRoute.selectedAircraft!,
      aircraftList:
          tempRoute.aircraft.isNotEmpty
              ? tempRoute.aircraft
              : [tempRoute.selectedAircraft!],
      flightsPerWeek: tempRoute.flightsPerWeek!,
      freeFood: tempRoute.freeFood!,
    );
  }

  /// Checks if the route has all required data for creation
  bool get isComplete {
    return startAirport != null &&
        endAirport != null &&
        selectedAircraft != null &&
        flightsPerWeek != null &&
        freeFood != null;
  }

  /// Gets the distance of this route in kilometers
  int get distanceKm {
    if (startAirport == null || endAirport == null) return 0;
    return startAirport!.distanceTo(endAirport!).round();
  }

  /// Gets a formatted route name for display
  String get routeName {
    if (startAirport == null || endAirport == null)
      return "Unvollständige Route";
    return "${startAirport!.iataCode} → ${endAirport!.iataCode}";
  }

  /// Adds an aircraft to this route
  void addAircraft(Aircraft newAircraft) {
    if (!aircraft.contains(newAircraft)) {
      aircraft.add(newAircraft);
      // Set as primary aircraft if none selected
      if (selectedAircraft == null) {
        selectedAircraft = newAircraft;
      }
    }
  }

  /// Removes an aircraft from this route
  void removeAircraft(Aircraft aircraftToRemove) {
    aircraft.remove(aircraftToRemove);
    // If removing primary aircraft, select new primary
    if (selectedAircraft == aircraftToRemove) {
      selectedAircraft = aircraft.isNotEmpty ? aircraft.first : null;
    }
  }

  /// Gets the number of aircraft assigned to this route
  int get aircraftCount => aircraft.length;

  /// Gets a formatted string of all aircraft on this route
  String get aircraftDisplay {
    if (aircraft.isEmpty && selectedAircraft != null) {
      return selectedAircraft!.model;
    }
    if (aircraft.isEmpty) return "Keine Flugzeuge";
    if (aircraft.length == 1) return aircraft.first.model;
    return "${aircraft.length}x ${aircraft.first.model}";
  }

  /// Calculates the total passenger capacity for this route
  /// Based on flights per week and passengers per aircraft
  /// Returns total weekly passenger capacity
  double calculateCapacity() {
    if ((aircraft.isEmpty && selectedAircraft == null) ||
        flightsPerWeek == null)
      return 0.0;

    // Standard passenger count per aircraft (can be made dynamic later)
    const int passengersPerAircraft = 180;

    // Use aircraft count or fallback to 1 for selectedAircraft
    int aircraftCountForCalc = aircraft.isNotEmpty ? aircraft.length : 1;

    // Calculate total weekly capacity: aircraft count × flights × passengers
    final double capacity =
        aircraftCountForCalc *
        flightsPerWeek! *
        passengersPerAircraft.toDouble();

    return capacity;
  }

  /// Returns a formatted string displaying the route's capacity
  /// Provides user-friendly capacity information
  String getCapacityDisplay() {
    final capacity = calculateCapacity();
    return 'Capacity: ${capacity.toStringAsFixed(0)} Passengers per Week';
  }

  // TODO: Add methods for:
  // - Revenue calculation
  // - Operating cost calculation
  // - Profitability analysis
  // - Route efficiency metrics
}
