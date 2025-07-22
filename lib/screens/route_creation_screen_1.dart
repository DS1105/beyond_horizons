import 'package:flutter/material.dart';
import 'package:beyond_horizons/models/airport.dart';
import 'package:beyond_horizons/services/airport_data_service.dart';
import 'package:beyond_horizons/screens/route_creation_screen_2.dart';

/// Einfacher Route Creation Screen
/// Nur Flughafen-Auswahl und Distanz-Berechnung
class RouteCreationScreen1 extends StatefulWidget {
  @override
  _RouteCreationScreen1State createState() => _RouteCreationScreen1State();
}

class _RouteCreationScreen1State extends State<RouteCreationScreen1> {
  // Verfügbare Flughäfen
  List<Airport> availableAirports = [];

  // Ausgewählte Flughäfen
  Airport? selectedStartAirport;
  Airport? selectedDestinationAirport;

  // Text Controller für Suchfelder
  final TextEditingController startController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  // Gefilterte Listen für Dropdown
  List<Airport> filteredStartAirports = [];
  List<Airport> filteredDestinationAirports = [];

  // Dropdown-Sichtbarkeit
  bool showStartDropdown = false;
  bool showDestinationDropdown = false;

  @override
  void initState() {
    super.initState();
    _loadAirports();
  }

  @override
  void dispose() {
    startController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  /// Flughäfen laden
  Future<void> _loadAirports() async {
    try {
      final airports = await AirportDataService.getAllAirports();
      setState(() {
        availableAirports = airports;
      });
    } catch (e) {
      print('Fehler beim Laden der Flughäfen: $e');
    }
  }

  /// Start-Flughäfen filtern
  void _filterStartAirports(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStartAirports =
            availableAirports
                .where((airport) => airport != selectedDestinationAirport)
                .toList();
      } else {
        filteredStartAirports =
            availableAirports
                .where(
                  (airport) =>
                      airport != selectedDestinationAirport &&
                      (airport.name.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ||
                          airport.iataCode.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ||
                          airport.city.toLowerCase().contains(
                            query.toLowerCase(),
                          )),
                )
                .toList();
      }
      showStartDropdown = filteredStartAirports.isNotEmpty;
    });
  }

  /// Ziel-Flughäfen filtern
  void _filterDestinationAirports(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredDestinationAirports =
            availableAirports
                .where((airport) => airport != selectedStartAirport)
                .toList();
      } else {
        filteredDestinationAirports =
            availableAirports
                .where(
                  (airport) =>
                      airport != selectedStartAirport &&
                      (airport.name.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ||
                          airport.iataCode.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ||
                          airport.city.toLowerCase().contains(
                            query.toLowerCase(),
                          )),
                )
                .toList();
      }
      showDestinationDropdown = filteredDestinationAirports.isNotEmpty;
    });
  }

  /// Start-Flughafen auswählen
  void _selectStartAirport(Airport airport) {
    setState(() {
      selectedStartAirport = airport;
      startController.text = "${airport.name} (${airport.iataCode})";
      showStartDropdown = false;

      // Ziel löschen falls gleich wie Start
      if (selectedDestinationAirport == airport) {
        selectedDestinationAirport = null;
        destinationController.clear();
      }
    });
  }

  /// Ziel-Flughafen auswählen
  void _selectDestinationAirport(Airport airport) {
    setState(() {
      selectedDestinationAirport = airport;
      destinationController.text = "${airport.name} (${airport.iataCode})";
      showDestinationDropdown = false;

      // Start löschen falls gleich wie Ziel
      if (selectedStartAirport == airport) {
        selectedStartAirport = null;
        startController.clear();
      }
    });
  }

  /// Distanz berechnen
  double? _calculateDistance() {
    if (selectedStartAirport != null && selectedDestinationAirport != null) {
      return selectedStartAirport!.distanceTo(selectedDestinationAirport!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double? distance = _calculateDistance();

    return Scaffold(
      appBar: AppBar(title: Text("Route erstellen")),
      body: GestureDetector(
        onTap: () {
          // Dropdowns schließen beim Tippen außerhalb
          setState(() {
            showStartDropdown = false;
            showDestinationDropdown = false;
          });
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titel
              Text(
                "Neue Route",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),

              // Start-Flughafen
              Text(
                "Von:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: startController,
                decoration: InputDecoration(
                  hintText: "Start-Flughafen suchen...",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: _filterStartAirports,
                onTap: () {
                  _filterStartAirports(startController.text);
                },
              ),

              // Start-Dropdown
              if (showStartDropdown)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                  ),
                  child: ListView.builder(
                    itemCount: filteredStartAirports.length,
                    itemBuilder: (context, index) {
                      final airport = filteredStartAirports[index];
                      return ListTile(
                        title: Text("${airport.name} (${airport.iataCode})"),
                        subtitle: Text("${airport.city}, ${airport.country}"),
                        onTap: () => _selectStartAirport(airport),
                      );
                    },
                  ),
                ),

              SizedBox(height: 20),

              // Ziel-Flughafen
              Text(
                "Nach:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: destinationController,
                decoration: InputDecoration(
                  hintText: "Ziel-Flughafen suchen...",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: _filterDestinationAirports,
                onTap: () {
                  _filterDestinationAirports(destinationController.text);
                },
              ),

              // Ziel-Dropdown
              if (showDestinationDropdown)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                  ),
                  child: ListView.builder(
                    itemCount: filteredDestinationAirports.length,
                    itemBuilder: (context, index) {
                      final airport = filteredDestinationAirports[index];
                      return ListTile(
                        title: Text("${airport.name} (${airport.iataCode})"),
                        subtitle: Text("${airport.city}, ${airport.country}"),
                        onTap: () => _selectDestinationAirport(airport),
                      );
                    },
                  ),
                ),

              SizedBox(height: 30),

              // Distanz-Anzeige
              if (distance != null)
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.flight_takeoff, color: Colors.blue),
                            SizedBox(width: 10),
                            Text(
                              "Route-Info",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${selectedStartAirport!.iataCode} → ${selectedDestinationAirport!.iataCode}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Entfernung: ${distance.round()} km",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              Spacer(),

              // Route erstellen Button
              if (selectedStartAirport != null &&
                  selectedDestinationAirport != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RouteCreationScreen2(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text("Weiter", style: TextStyle(fontSize: 18)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
