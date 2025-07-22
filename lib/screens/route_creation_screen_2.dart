import 'package:flutter/material.dart';
import 'package:beyond_horizons/screens/route_creation_screen_3.dart';
import 'package:beyond_horizons/models/aircraft.dart';
import 'package:beyond_horizons/models/route.dart' as RouteModel;
import 'package:beyond_horizons/services/fleet_manager.dart';

/// Route Creation Screen 2
/// Flugzeug-Auswahl für die Route
class RouteCreationScreen2 extends StatefulWidget {
  final RouteModel.Route route; // Temporary route from previous screen

  const RouteCreationScreen2({Key? key, required this.route}) : super(key: key);

  @override
  _RouteCreationScreen2State createState() => _RouteCreationScreen2State();
}

class _RouteCreationScreen2State extends State<RouteCreationScreen2> {
  List<Aircraft> selectedAircraftList =
      []; // Liste aller ausgewählten Flugzeuge

  @override
  void initState() {
    super.initState();
    // Initialize selected aircraft from route (for back navigation)
    selectedAircraftList = List.from(widget.route.aircraft);
  }

  @override
  Widget build(BuildContext context) {
    List<Aircraft> availableAircraft = FleetManager()
        .getAvailableAircraftForRoute(widget.route.distanceKm);

    return Scaffold(
      appBar: AppBar(
        title: Text("Flugzeug wählen"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Route Info
            _buildRouteInfo(),
            SizedBox(height: 20),

            // Flugzeug-Liste oder Empty State
            availableAircraft.isEmpty
                ? _buildNoAircraftMessage()
                : _buildAircraftList(availableAircraft),

            Spacer(),

            // Weiter Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    selectedAircraftList.isNotEmpty
                        ? () {
                          // Clear existing aircraft from route first
                          widget.route.aircraft.clear();

                          // Add all selected aircraft to the route
                          for (var aircraft in selectedAircraftList) {
                            widget.route.addAircraft(aircraft);
                          }

                          // Set first aircraft as selectedAircraft for backward compatibility
                          if (selectedAircraftList.isNotEmpty) {
                            widget.route.selectedAircraft =
                                selectedAircraftList.first;
                          } else {
                            widget.route.selectedAircraft = null;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => RouteCreationScreen3(
                                    route:
                                        widget
                                            .route, // Pass route to next screen
                                  ),
                            ),
                          );
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  selectedAircraftList.isEmpty
                      ? "Flugzeug auswählen"
                      : "Weiter (${selectedAircraftList.length} Flugzeuge)",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Route",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "${widget.route.startAirport!.name} → ${widget.route.endAirport!.name}",
            ),
            Text("Entfernung: ${widget.route.distanceKm} km"),
          ],
        ),
      ),
    );
  }

  Widget _buildNoAircraftMessage() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flight_takeoff, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "Keine passenden Flugzeuge",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Für diese Route sind keine Flugzeuge verfügbar.\nKaufen Sie Flugzeuge mit ausreichender Reichweite.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAircraftList(List<Aircraft> aircraft) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Verfügbare Flugzeuge",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),

          // Ausgewählte Flugzeuge anzeigen
          if (selectedAircraftList.isNotEmpty) ...[
            _buildSelectedAircraftInfo(),
            SizedBox(height: 16),
          ],

          Expanded(
            child: ListView.builder(
              itemCount: aircraft.length,
              itemBuilder: (context, index) {
                final aircraftItem = aircraft[index];
                return _buildAircraftCard(aircraftItem);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAircraftCard(Aircraft aircraft) {
    final isSelected = selectedAircraftList.any((a) => a.id == aircraft.id);

    return Card(
      color: isSelected ? Colors.blue[50] : null,
      child: ListTile(
        leading: Icon(
          Icons.flight,
          color: isSelected ? Colors.blue : Colors.grey,
          size: 32,
        ),
        title: Text(
          aircraft.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.blue : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ID: ${aircraft.id} • ${aircraft.model}"),
            Text(
              "Reichweite: ${aircraft.range} km • ${aircraft.seatCapacity} Sitze",
            ),
          ],
        ),
        trailing:
            isSelected
                ? Icon(Icons.check_circle, color: Colors.blue)
                : Icon(Icons.add_circle_outline, color: Colors.grey),
        onTap: () {
          setState(() {
            if (isSelected) {
              // Flugzeug entfernen
              selectedAircraftList.removeWhere((a) => a.id == aircraft.id);
            } else {
              // Flugzeug hinzufügen
              selectedAircraftList.add(aircraft);
            }
          });
        },
      ),
    );
  }

  /// Widget für die Anzeige der ausgewählten Flugzeuge
  Widget _buildSelectedAircraftInfo() {
    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text(
                  "Ausgewählte Flugzeuge (${selectedAircraftList.length})",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children:
                  selectedAircraftList.map((aircraft) {
                    return Chip(
                      avatar: Icon(Icons.flight, size: 16, color: Colors.blue),
                      label: Text(
                        aircraft.name,
                        style: TextStyle(fontSize: 12),
                      ),
                      backgroundColor: Colors.blue[100],
                      onDeleted: () {
                        setState(() {
                          selectedAircraftList.removeWhere(
                            (a) => a.id == aircraft.id,
                          );
                        });
                      },
                    );
                  }).toList(),
            ),
            SizedBox(height: 8),
            Text(
              "💡 Alle Flugzeuge werden für die Kapazitätsberechnung verwendet",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
