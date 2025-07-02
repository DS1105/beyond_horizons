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

  /// Constructor for creating a new Aircraft instance
  /// Automatically assigns a unique ID to each aircraft
  Aircraft({
    required this.name,
    required this.model,
    required this.seatCapacity,
    required this.range,
    required this.fuelConsumptionPerHour,
  }) : id = _idCounter++; // Auto-increment ID for each new aircraft

  // TODO: Add methods for calculating operating costs, fuel efficiency, etc.
}
