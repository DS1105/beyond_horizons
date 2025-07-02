/// Flight route model representing a connection between two airports
/// Manages route-specific data including aircraft assignment and capacity calculations
import 'package:beyond_horizons/models/airport.dart';
import 'aircraft.dart';

/// FlightRoute class representing an active flight route in the simulation
/// Connects two airports with assigned aircraft and flight schedules
class FlightRoute {
  final Airport startAirport; // Departure airport
  final Airport destinationAirport; // Arrival airport
  final List<Aircraft> aircraft; // Aircraft assigned to this route
  int flightsPerWeek; // Number of flights per week on this route
  final Map<String, double>
  ticketPrices; // Ticket prices by class (Economy, Business, etc.)
  bool onboardService; // Whether onboard services are provided

  /// Constructor for creating a new FlightRoute
  /// Requires airports, aircraft, and operational parameters
  FlightRoute({
    required this.startAirport,
    required this.destinationAirport,
    required this.aircraft, // List of aircraft operating this route
    required this.flightsPerWeek, // Weekly flight frequency
    required this.ticketPrices, // Pricing structure
    required this.onboardService, // Service level
  });

  /// Calculates the total passenger capacity for this route
  /// Based on number of aircraft, flights per week, and passengers per aircraft
  /// Returns total weekly passenger capacity
  double calculateCapacity() {
    // Standard passenger count per aircraft (can be made dynamic later)
    const int passengersPerAircraft = 180;

    // Convert flights per week to double for calculation
    double flightsPerWeekDouble = flightsPerWeek.toDouble();

    // Calculate total weekly capacity: aircraft × flights × passengers
    final double capacity =
        aircraft.length * flightsPerWeekDouble * passengersPerAircraft;

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
