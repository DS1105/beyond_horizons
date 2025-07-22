/// Aircraft model class representing different aircraft types in the simulation
/// Each aircraft has unique characteristics affecting performance and capacity
class Aircraft {
  static int _idCounter = 1; // Static counter for generating unique IDs
  final int id; // Unique identifier for each aircraft instance
  final String name; // Display name of the aircraft
  final String model; // Specific model designation (e.g., "A320-200")
  final int seatCapacity; // Maximum number of passengers
  final int range; // Maximum flight distance in kilometers
  final int fuelConsumptionPerHour; // Fuel consumption in liters per hour
  final int purchasePrice; // Purchase price in USD (full amount)
  final int cruiseSpeed; // Cruise speed in km/h
  final int turnaroundTimeMinutes; // Turnaround time at gate in minutes
  bool isAssignedToRoute; // Whether this aircraft is assigned to a route

  /// Constructor for creating a new Aircraft instance
  /// Automatically assigns a unique ID to each aircraft
  Aircraft({
    required this.name,
    required this.model,
    required this.seatCapacity,
    required this.range,
    required this.fuelConsumptionPerHour,
    required this.purchasePrice,
    required this.cruiseSpeed,
    required this.turnaroundTimeMinutes,
    this.isAssignedToRoute = false,
  }) : id = _idCounter++; // Auto-increment ID for each new aircraft

  /// Template constructor for display purposes (doesn't consume ID)
  Aircraft.template({
    required this.name,
    required this.model,
    required this.seatCapacity,
    required this.range,
    required this.fuelConsumptionPerHour,
    required this.purchasePrice,
    required this.cruiseSpeed,
    required this.turnaroundTimeMinutes,
  }) : id = 0,
       isAssignedToRoute = false; // Template has ID 0, doesn't consume real IDs

  /// Formats the purchase price for display in the UI
  /// Returns formatted string like "110 Mio. USD" or "1,5 Mio. USD" or "500.000 USD"
  String get formattedPrice {
    if (purchasePrice >= 1000000) {
      double millions = purchasePrice / 1000000;
      if (millions == millions.round()) {
        return "${millions.round()} Mio. USD";
      } else {
        return "${millions.toStringAsFixed(1).replaceAll('.', ',')} Mio. USD";
      }
    } else {
      return "${purchasePrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} USD";
    }
  }

  /// Calculates maximum flights per week for a given route distance
  /// Takes into account flight time, turnaround time, and taxi times
  int calculateMaxFlightsPerWeek(int routeDistanceKm) {
    const int taxiTimeMinutesPerAirport =
        10; // Landing to gate + gate to takeoff
    const int maxOperatingHoursPerWeek =
        16 * 7; // 112 hours per week - realistic operation limit

    // Flight time for round trip (there and back) in hours
    double flightTimeHours = (routeDistanceKm * 2) / cruiseSpeed;

    // Turnaround time at both airports in hours
    double turnaroundHours = (turnaroundTimeMinutes * 2) / 60;

    // Taxi time at both airports (4 times: land+taxi, taxi+takeoff at each airport) in hours
    double taxiHours = (taxiTimeMinutesPerAirport * 4) / 60;

    // Total time per round trip
    double totalTimePerRound = flightTimeHours + turnaroundHours + taxiHours;

    // Calculate maximum possible flights per week
    int maxFlights = (maxOperatingHoursPerWeek / totalTimePerRound).floor();

    return maxFlights > 0
        ? maxFlights
        : 1; // At least 1 flight should be possible
  }

  // TODO: Add methods for calculating operating costs, fuel efficiency, etc.
}
