import 'package:flutter/material.dart';
import 'package:beyond_horizons/services/route_manager.dart';
import 'package:beyond_horizons/models/route.dart' as RouteModel;
import 'package:beyond_horizons/screens/route_creation_screen_1.dart';

/// Screen für Routen-Übersicht und Verwaltung
class RoutesOverviewScreen extends StatefulWidget {
  @override
  _RoutesOverviewScreenState createState() => _RoutesOverviewScreenState();
}

class _RoutesOverviewScreenState extends State<RoutesOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    final routes = RouteManager().getAllRoutes();

    return Scaffold(
      appBar: AppBar(title: Text("Routen-Übersicht")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Alle Routen",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Routen-Liste oder Placeholder
            Expanded(
              child:
                  routes.isEmpty
                      ? Center(
                        child: Text(
                          "Noch keine Routen erstellt",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        itemCount: routes.length,
                        itemBuilder: (context, index) {
                          final route = routes[index];
                          return _buildRouteCard(route);
                        },
                      ),
            ),

            // Button für neue Route
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RouteCreationScreen1(),
                  ),
                );
              },
              child: Text("Neue Route erstellen"),
            ),
          ],
        ),
      ),
    );
  }

  /// Erstellt eine Karte für eine Route (ähnlich wie Flugzeug-Karten)
  Widget _buildRouteCard(RouteModel.Route route) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => _showRouteDetails(route),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Route-Name und Status
              Row(
                children: [
                  Icon(Icons.flight_takeoff, color: Colors.blue, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          route.routeName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${route.distanceKm} km",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "ID: ${route.id}",
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Flugzeuge und Frequenz
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Flugzeuge:",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          route.aircraftDisplay,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Frequenz:",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          "${route.flightsPerWeek ?? 0}x pro Woche",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),

              // Kapazität
              Text(
                route.getCapacityDisplay(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Zeigt Details einer Route in einem Dialog
  void _showRouteDetails(RouteModel.Route route) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(route.routeName),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDetailRow("Route ID", "${route.id}"),
                  _buildDetailRow(
                    "Start",
                    route.startAirport?.name ?? "Unbekannt",
                  ),
                  _buildDetailRow(
                    "Ziel",
                    route.endAirport?.name ?? "Unbekannt",
                  ),
                  _buildDetailRow("Entfernung", "${route.distanceKm} km"),
                  _buildDetailRow(
                    "Flugzeuge",
                    "${route.aircraftCount} (${route.aircraftDisplay})",
                  ),
                  _buildDetailRow(
                    "Flüge pro Woche",
                    "${route.flightsPerWeek ?? 0}",
                  ),
                  _buildDetailRow(
                    "Kostenlose Verpflegung",
                    route.freeFood == true ? "Ja" : "Nein",
                  ),
                  _buildDetailRow(
                    "Wöchentliche Kapazität",
                    route.getCapacityDisplay().replaceAll("Capacity: ", ""),
                  ),

                  SizedBox(height: 16),
                  Text(
                    "Flugzeug-Details:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ...route.aircraft
                      .map(
                        (aircraft) => Padding(
                          padding: EdgeInsets.only(left: 16, bottom: 4),
                          child: Text(
                            "• ${aircraft.name} (ID: ${aircraft.id})",
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Schließen"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Route bearbeiten
                },
                child: Text("Bearbeiten"),
              ),
            ],
          ),
    );
  }

  /// Hilfsmethode für Detail-Zeilen
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
