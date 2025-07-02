/// Airport card widget for displaying airport information in a card format
/// Provides a reusable UI component for showing airport details
import 'package:flutter/material.dart';
import '../models/airport.dart';

/// Reusable widget for displaying airport information
/// Creates a material design card with airport name and location
class AirportCard extends StatelessWidget {
  final Airport airport; // Airport data to display

  /// Constructor requiring an Airport instance
  AirportCard({required this.airport});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Material design card containing airport information
      child: ListTile(
        leading:
            airport.isHub
                ? Icon(Icons.hub, color: Colors.blue)
                : Icon(Icons.flight_takeoff, color: Colors.grey),
        title: Text(
          "${airport.name} (${airport.iataCode})",
        ), // Primary text: airport name with IATA
        subtitle: Text(
          "${airport.city}, ${airport.country} • ${airport.hubLevelDescription}",
        ), // Secondary text: location and hub level
        trailing:
            airport.isCongested
                ? Icon(Icons.warning, color: Colors.orange)
                : Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}
