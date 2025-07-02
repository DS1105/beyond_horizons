/// Aircraft purchase screen for buying new aircraft
/// Allows players to expand their fleet by purchasing different aircraft types
import 'package:flutter/material.dart';
import 'package:beyond_horizons/models/aircraft.dart';
import 'package:beyond_horizons/models/aircraft_types/a320_200.dart'; // Example aircraft type

/// Screen for purchasing aircraft
/// Displays available aircraft types and manages the purchase process
class AircraftPurchaseScreen extends StatefulWidget {
  @override
  _AircraftPurchaseScreenState createState() => _AircraftPurchaseScreenState();
}

/// State class for the aircraft purchase screen
/// Manages the list of purchased aircraft and purchase transactions
class _AircraftPurchaseScreenState extends State<AircraftPurchaseScreen> {
  /// List to store aircraft purchased in this session
  /// Will be returned to the calling screen when navigation completes
  final List<Aircraft> purchasedAircraft = [];

  /// Function to purchase a new aircraft
  /// Currently only supports A320-200, but can be extended for multiple types
  void purchaseAircraft() {
    setState(() {
      // Create a new A320-200 aircraft instance
      final newAircraft = A320_200(); // TODO: Add aircraft selection UI
      purchasedAircraft.add(newAircraft);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Aircraft Purchase")), // Screen title
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Purchase button - currently only purchases A320-200
            ElevatedButton(
              onPressed: purchaseAircraft,
              child: Text(
                "Purchase Aircraft",
              ), // TODO: Add aircraft type selection
            ),
            SizedBox(height: 20),
            Text("Purchased Aircraft:"), // Header for aircraft list
            // Scrollable list of purchased aircraft
            Expanded(
              child: ListView.builder(
                itemCount: purchasedAircraft.length,
                itemBuilder: (context, index) {
                  final aircraft = purchasedAircraft[index];
                  return ListTile(
                    title: Text(
                      "${aircraft.name} - ID: ${aircraft.id}",
                    ), // Aircraft name and unique ID
                    subtitle: Text(
                      "Model: ${aircraft.model}, Capacity: ${aircraft.seatCapacity} Passengers", // Aircraft specifications
                    ),
                  );
                },
              ),
            ),
            // Return to previous screen with purchased aircraft
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  purchasedAircraft, // Pass purchased aircraft back to calling screen
                );
              },
              child: Text("Back to Home Page"), // Navigation button
            ),
          ],
        ),
      ),
    );
  }
}
