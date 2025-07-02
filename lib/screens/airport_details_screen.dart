/// Airport details screen showing comprehensive airport information
/// Displays detailed capacity and operational data for a selected airport
import 'package:beyond_horizons/models/airport.dart';
import 'package:flutter/material.dart';

/// Screen for displaying detailed information about a specific airport
/// Shows capacity utilization, location, and operational details
class AirportDetailsScreen extends StatelessWidget {
  final Airport airport; // Airport to display details for

  /// Constructor requiring an Airport instance to display
  AirportDetailsScreen({required this.airport});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dynamic app bar title showing airport name with IATA code
      appBar: AppBar(
        title: Text("${airport.name} (${airport.iataCode}) Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Airport header with hub indicator
              Row(
                children: [
                  airport.isHub
                      ? Icon(Icons.hub, color: Colors.blue, size: 24)
                      : Icon(
                        Icons.flight_takeoff,
                        color: Colors.grey,
                        size: 24,
                      ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "${airport.name} (${airport.iataCode})",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  airport.isCongested
                      ? Icon(Icons.warning, color: Colors.orange, size: 24)
                      : Icon(Icons.check_circle, color: Colors.green, size: 24),
                ],
              ),
              SizedBox(height: 16),

              // Basic Information Card
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Basic Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "ICAO Code: ${airport.icaoCode}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "City: ${airport.city}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Country: ${airport.country}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Region: ${airport.region}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Hub Level: ${airport.hubLevelDescription}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Coordinates: ${airport.latitude.toStringAsFixed(4)}, ${airport.longitude.toStringAsFixed(4)}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Capacity Information Card
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Capacity Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),

                      // Slot capacity with progress indicator
                      Text(
                        "Slot Capacity:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${airport.currentSlotUsage} / ${airport.slotCapacity} (${airport.slotUtilizationPercentage.toStringAsFixed(1)}%)",
                        style: TextStyle(fontSize: 16),
                      ),
                      LinearProgressIndicator(
                        value: airport.slotUtilizationPercentage / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          airport.slotUtilizationPercentage > 80
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                      SizedBox(height: 12),

                      // Terminal capacity with progress indicator
                      Text(
                        "Terminal Capacity:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${airport.currentTerminalUsage} / ${airport.terminalCapacity} (${airport.terminalUtilizationPercentage.toStringAsFixed(1)}%)",
                        style: TextStyle(fontSize: 16),
                      ),
                      LinearProgressIndicator(
                        value: airport.terminalUtilizationPercentage / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          airport.terminalUtilizationPercentage > 80
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                      SizedBox(height: 12),

                      Text(
                        "Max Expansion Capacity: ${airport.maxCapacity}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Status Information Card
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Operational Status",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            airport.isCongested
                                ? Icons.warning
                                : Icons.check_circle,
                            color:
                                airport.isCongested
                                    ? Colors.orange
                                    : Colors.green,
                          ),
                          SizedBox(width: 8),
                          Text(
                            airport.isCongested
                                ? "Congested"
                                : "Operating Normally",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      if (airport.isCongested) ...[
                        SizedBox(height: 8),
                        Text(
                          "Warning: Airport utilization exceeds 80% in at least one category.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange[700],
                          ),
                        ),
                      ],
                      SizedBox(height: 8),
                      Text(
                        "Available Slots: ${airport.availableSlotCapacity}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Available Terminal Space: ${airport.availableTerminalCapacity}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
