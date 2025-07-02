// Import statements for required models and screens
import 'package:beyond_horizons/models/airport.dart';
import 'package:beyond_horizons/models/airline.dart';
import 'package:beyond_horizons/models/aircraft.dart';
import 'package:beyond_horizons/screens/route_creation_screen.dart';
import 'package:beyond_horizons/screens/aircraft_purchase_screen.dart'; // Aircraft purchase functionality
import 'package:beyond_horizons/services/airport_data_service.dart';
import 'package:flutter/material.dart';

/// Main home screen of the airline simulation app
/// Displays available airports and provides navigation to other features
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/// State class for the HomeScreen widget
/// Manages airport data and aircraft purchases
class _HomeScreenState extends State<HomeScreen> {
  /// List of available airports in the simulation - loaded from central data
  List<Airport> airportList = [];

  /// List of aircraft purchased by the player
  /// Starts empty and gets populated through purchases
  List<Aircraft> purchasedAircraft = [];

  @override
  void initState() {
    super.initState();
    // Load airports from central data source
    _loadAirports();
  }

  /// Load airports using the new async data service
  Future<void> _loadAirports() async {
    try {
      final airports = await AirportDataService.getAllAirports();
      setState(() {
        airportList = airports;
      });
    } catch (e) {
      print('Error loading airports: $e');
      // Show error message to user
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load airport data')));
    }
  }

  /// Updates airport capacity when new routes are created
  /// [airport] - The airport to update
  /// [usedSlots] - Number of additional slots to mark as used
  void updateCapacity(Airport airport, int usedSlots) {
    setState(() {
      airport.currentSlotUsage += usedSlots; // Increase used slots
    });
  }

  /// Builds the main UI for the home screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Screen")), // Main navigation bar

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header text for airport list
            Text("Available Airports:", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            // Scrollable list of available airports
            Expanded(
              child: ListView.builder(
                itemCount: airportList.length,
                itemBuilder: (context, index) {
                  final airport = airportList[index];
                  return ListTile(
                    leading:
                        airport.isHub
                            ? Icon(Icons.hub, color: Colors.blue)
                            : Icon(Icons.flight_takeoff, color: Colors.grey),
                    title: Text(
                      "${airport.name} (${airport.iataCode})",
                    ), // Airport name with IATA
                    subtitle: Text(
                      // Detailed airport information with hub level
                      "${airport.city}, ${airport.country} • ${airport.hubLevelDescription}\n"
                      "Available Slots: ${airport.availableSlotCapacity} / ${airport.slotCapacity}\n"
                      "Terminal Capacity: ${airport.availableTerminalCapacity} / ${airport.terminalCapacity}",
                    ),
                    trailing:
                        airport.isCongested
                            ? Icon(Icons.warning, color: Colors.orange)
                            : Icon(Icons.check_circle, color: Colors.green),
                    // Navigate to route creation when airport is tapped
                    onTap: () async {
                      final route = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => RouteCreationScreen(
                                airline: Airline(
                                  name: 'Air Berlin', // Default airline name
                                  airport: airport, // Base airport for airline
                                ),
                                purchasedAircraft:
                                    purchasedAircraft, // Pass owned aircraft list
                                initialStartAirport:
                                    airport, // Pre-select this airport as start
                              ),
                        ),
                      );
                      // Update airport capacity if route was successfully created
                      if (route != null) {
                        // Calculate slot usage: flights per week * estimated passengers per flight
                        updateCapacity(airport, route.flightsPerWeek * 180);
                      }
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            // Button to create a new route between first and last airports
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => RouteCreationScreen(
                          airline: Airline(
                            name: 'Air Berlin', // Default airline
                            airport: airportList.first, // Base at first airport
                          ),
                          purchasedAircraft:
                              purchasedAircraft, // Pass owned aircraft
                          initialStartAirport:
                              airportList.first, // First airport in list
                          initialDestinationAirport:
                              airportList.last, // Last airport in list
                        ),
                  ),
                );
              },
              child: Text("Create Route"), // Direct route creation button
            ),
            // Button to navigate to aircraft purchase screen
            ElevatedButton(
              onPressed: () async {
                // Navigate to aircraft purchase screen and wait for result
                final purchasedAircraftResult = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AircraftPurchaseScreen(),
                  ),
                );
                // Add newly purchased aircraft to the fleet
                if (purchasedAircraftResult != null) {
                  setState(() {
                    purchasedAircraft.addAll(
                      purchasedAircraftResult, // Merge new aircraft into existing list
                    );
                  });
                }
              },
              child: Text("Purchase Aircraft"), // Aircraft purchase button
            ),

            // Placeholder button for future route viewing functionality
            ElevatedButton(
              onPressed: () {
                // TODO: Implement route viewing functionality
                // This will display all created routes and their details
              },
              child: Text(
                "View Routes",
              ), // Route viewing button (not implemented yet)
            ),
          ],
        ),
      ),
    );
  }
}
