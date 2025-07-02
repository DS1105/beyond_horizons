/// Airbus A320-200 aircraft implementation
/// Extends the base Aircraft class with specific A320-200 characteristics
/// One of the most popular narrow-body aircraft for short to medium-haul flights

import 'package:beyond_horizons/models/aircraft.dart';

/// A320-200 class with predefined specifications
/// Represents the Airbus A320-200 aircraft type commonly used by airlines
class A320_200 extends Aircraft {
  /// Creates a new A320-200 instance with standard specifications
  /// All parameters are preset to realistic values for this aircraft type
  A320_200()
    : super(
        name: "Airbus A320-200", // Full aircraft name
        model: "A320-200", // Model designation
        seatCapacity: 180, // Typical single-class configuration
        range: 6000, // Maximum range in kilometers
        fuelConsumptionPerHour: 2500, // Fuel consumption in liters per hour
      );
}
