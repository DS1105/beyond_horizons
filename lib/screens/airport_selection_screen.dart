/// Airport selection screen for choosing airports
/// Displays a list of available airports for route planning
import 'package:beyond_horizons/models/airport.dart';
import 'package:beyond_horizons/services/airport_data_service.dart';
import 'package:flutter/material.dart';

/// Screen for selecting an airport from the centralized data source
/// Used when users need to choose start or destination airports for routes
class AirportSelectionScreen extends StatefulWidget {
  @override
  _AirportSelectionScreenState createState() => _AirportSelectionScreenState();
}

class _AirportSelectionScreenState extends State<AirportSelectionScreen> {
  /// List of airports loaded from central data source
  List<Airport> airportList = [];
  List<Airport> filteredAirports = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load airports from JSON data source
    _loadAirports();
  }

  /// Load airports from JSON-based data service
  Future<void> _loadAirports() async {
    try {
      final airports = await AirportDataService.getAllAirports();
      setState(() {
        airportList = airports;
        filteredAirports = List.from(airportList);
      });
    } catch (e) {
      print('Error loading airports: $e');
      // Set empty list as fallback
      setState(() {
        airportList = [];
        filteredAirports = [];
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  /// Filter airports based on search query
  void filterAirports(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredAirports = List.from(airportList);
      } else {
        filteredAirports =
            airportList.where((airport) {
              return airport.name.toLowerCase().contains(query.toLowerCase()) ||
                  airport.city.toLowerCase().contains(query.toLowerCase()) ||
                  airport.country.toLowerCase().contains(query.toLowerCase()) ||
                  airport.iataCode.toLowerCase().contains(query.toLowerCase());
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Airport")), // Screen title
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search airports by name, city, or IATA code...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                suffixIcon:
                    searchController.text.isNotEmpty
                        ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            filterAirports('');
                          },
                        )
                        : null,
              ),
              onChanged: filterAirports,
            ),
          ),
          // Airport list
          Expanded(
            child: ListView.builder(
              itemCount:
                  filteredAirports.length, // Build list items for each airport
              itemBuilder: (context, index) {
                final airport = filteredAirports[index];
                return ListTile(
                  leading:
                      airport.isHub
                          ? Icon(Icons.hub, color: Colors.blue)
                          : Icon(Icons.flight_takeoff, color: Colors.grey),
                  title: Text(
                    "${airport.name} (${airport.iataCode})",
                  ), // Airport name with IATA
                  subtitle: Text(
                    // Detailed airport information as secondary text
                    "Available Slots: ${airport.availableSlotCapacity} / ${airport.slotCapacity}",
                  ),
                  trailing:
                      airport.isCongested
                          ? Icon(Icons.warning, color: Colors.orange)
                          : Icon(Icons.check_circle, color: Colors.green),
                  onTap: () {
                    // Return selected airport to calling screen
                    Navigator.pop(context, airport);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
