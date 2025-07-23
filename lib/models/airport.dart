/// Airport model class representing an airport in the airline simulation
/// Contains information about capacity, usage, expansion capabilities, and location data
import 'dart:math' as math;

class Airport {
  String name; // Name of the airport
  String iataCode; // 3-letter IATA code (e.g., "FRA", "JFK")
  String icaoCode; // 4-letter ICAO code (e.g., "EDDF", "KJFK")
  String country; // Country where the airport is located
  String city; // City where the airport is located
  String region; // Geographic region (e.g., "Europe", "North America")
  int slotCapacity; // Total capacity for slots (Takeoff/Landing)
  int currentSlotUsage; // Currently used capacity for slots
  int terminalCapacity; // Total capacity of the terminal
  int currentTerminalUsage; // Currently used capacity for terminals
  int maxCapacity; // Maximum capacity for the airport overall
  bool permissionGranted; // Whether permission for expansion has been granted

  // Geographic coordinates for distance calculations
  double latitude; // Latitude coordinate
  double longitude; // Longitude coordinate

  // Demand classification - replaces hub system
  Map<String, int> demand; // Demand values for economy, business, first class

  /// Constructor for creating a new Airport instance
  /// Requires all capacity, location, and demand information
  Airport({
    required this.name,
    required this.iataCode,
    required this.icaoCode,
    required this.country,
    required this.city,
    required this.region,
    required this.slotCapacity,
    required this.currentSlotUsage,
    required this.terminalCapacity,
    required this.currentTerminalUsage,
    required this.maxCapacity,
    required this.latitude,
    required this.longitude,
    required this.demand,
    this.permissionGranted = false, // Default: no permission granted
  });

  /// Factory constructor for creating Airport from JSON data
  /// Supports loading airports from external JSON files
  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      name: json['name'] as String,
      iataCode: json['iataCode'] as String,
      icaoCode: json['icaoCode'] as String,
      country: json['country'] as String,
      city: json['city'] as String,
      region: json['region'] as String,
      slotCapacity: json['slotCapacity'] as int,
      currentSlotUsage: json['currentSlotUsage'] as int,
      terminalCapacity: json['terminalCapacity'] as int,
      currentTerminalUsage: json['currentTerminalUsage'] as int,
      maxCapacity: json['maxCapacity'] as int,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      demand: Map<String, int>.from(json['demand'] as Map),
      permissionGranted: json['permissionGranted'] as bool? ?? false,
    );
  }

  /// Getter for available slot capacity
  /// Returns the number of unused slots
  int get availableSlotCapacity {
    return slotCapacity - currentSlotUsage;
  }

  /// Getter for total capacity (slots + terminal)
  /// Returns combined capacity of slots and terminal
  int get capacity {
    return slotCapacity + terminalCapacity;
  }

  /// Getter for available terminal capacity
  /// Returns the number of unused terminal spaces
  int get availableTerminalCapacity {
    return terminalCapacity - currentTerminalUsage;
  }

  /// Getter for total available capacity (Slots + Terminal)
  /// Returns combined available capacity
  int get totalAvailableCapacity {
    return availableSlotCapacity + availableTerminalCapacity;
  }

  /// Method to check if capacity is sufficient
  /// Returns true if both slot and terminal capacity are not exceeded
  bool checkCapacity() {
    return (currentSlotUsage < slotCapacity) &&
        (currentTerminalUsage < terminalCapacity);
  }

  /// Method to expand the airport
  /// Requires permission to be granted first
  /// Supports PassengerTerminal and CargoTerminal expansion types
  void expand(String expansionType) {
    if (permissionGranted) {
      if (expansionType == 'PassengerTerminal') {
        terminalCapacity += 1000000; // Increase terminal capacity by 1 million
      } else if (expansionType == 'CargoTerminal') {
        slotCapacity += 500000; // Increase slot capacity by 500,000
      }
      print('The airport has been expanded with a $expansionType.');
    } else {
      print('Expansion not possible. Permission required.');
    }
  }

  /// Method to grant expansion permission
  /// Sets permissionGranted to true, allowing future expansions
  void grantPermission() {
    permissionGranted = true;
    print('Permission for expansion granted.');
  }

  /// Calculate distance to another airport in kilometers using Haversine formula
  /// Returns the great-circle distance between two airports
  double distanceTo(Airport other) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    double lat1Rad = latitude * (math.pi / 180);
    double lat2Rad = other.latitude * (math.pi / 180);
    double deltaLatRad = (other.latitude - latitude) * (math.pi / 180);
    double deltaLongRad = (other.longitude - longitude) * (math.pi / 180);

    double a =
        math.sin(deltaLatRad / 2) * math.sin(deltaLatRad / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLongRad / 2) *
            math.sin(deltaLongRad / 2);
    double c = 2 * math.asin(math.sqrt(a));

    return earthRadius * c;
  }

  /// Get airport display name with IATA code
  /// Returns formatted string like "Frankfurt Airport (FRA)"
  String get displayName => "$name ($iataCode)";

  /// Get short identifier combining city and IATA code
  /// Returns formatted string like "Frankfurt (FRA)"
  String get shortName => "$city ($iataCode)";

  /// Check if this airport is in the same city as another airport
  /// Useful for managing multiple airports per city
  bool isInSameCity(Airport other) {
    return city.toLowerCase() == other.city.toLowerCase() &&
        country.toLowerCase() == other.country.toLowerCase();
  }

  /// Get demand level description
  /// Returns human-readable demand classification based on economy demand
  String get demandLevelDescription {
    int economyDemand = demand['economy'] ?? 0;
    if (economyDemand >= 850) {
      return "Major International Hub";
    } else if (economyDemand >= 700) {
      return "International Hub";
    } else if (economyDemand >= 550) {
      return "Regional Hub";
    } else if (economyDemand >= 400) {
      return "Regional Airport";
    } else {
      return "Local Airport";
    }
  }

  /// Check if airport is a hub based on demand levels
  /// Returns true if economy demand is above hub threshold
  bool get isHub {
    int economyDemand = demand['economy'] ?? 0;
    return economyDemand >= 700; // Hub threshold
  }

  /// Get hub level equivalent based on demand
  /// Returns 1-5 scale compatible with existing code
  int get hubLevel {
    int economyDemand = demand['economy'] ?? 0;
    if (economyDemand >= 850) return 5;
    if (economyDemand >= 700) return 4;
    if (economyDemand >= 550) return 3;
    if (economyDemand >= 400) return 2;
    return 1;
  }

  /// Calculate utilization percentage for slots
  /// Returns percentage of slot capacity currently in use
  double get slotUtilizationPercentage {
    return (currentSlotUsage / slotCapacity) * 100;
  }

  /// Calculate utilization percentage for terminals
  /// Returns percentage of terminal capacity currently in use
  double get terminalUtilizationPercentage {
    return (currentTerminalUsage / terminalCapacity) * 100;
  }

  /// Check if airport is congested (over 80% utilization)
  /// Returns true if either slots or terminals are over 80% utilized
  bool get isCongested {
    return slotUtilizationPercentage > 80 || terminalUtilizationPercentage > 80;
  }

  /// String representation for debugging
  @override
  String toString() {
    return 'Airport{name: $name, iataCode: $iataCode, city: $city, country: $country, demandLevel: ${demand['economy']}}';
  }

  /// Equality operator for comparing airports
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Airport && other.iataCode == iataCode;
  }

  /// Hash code based on IATA code for efficient lookups
  @override
  int get hashCode => iataCode.hashCode;
}
