import 'package:flutter/material.dart';
import 'package:beyond_horizons/services/fleet_manager.dart';

/// Screen für die Anzeige der eigenen Flugzeuge
/// Zeigt alle gekauften Flugzeuge der Airline an
class OwnAircraftScreen extends StatefulWidget {
  @override
  _OwnAircraftScreenState createState() => _OwnAircraftScreenState();
}

class _OwnAircraftScreenState extends State<OwnAircraftScreen> {
  final FleetManager fleetManager = FleetManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eigene Flugzeuge"),
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
            // Titel
            Text(
              "Meine Flotte",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Flugzeugliste oder leerer Zustand
            Expanded(
              child:
                  fleetManager.aircraftCount > 0
                      ? _buildAircraftList()
                      : _buildEmptyState(),
            ),
          ],
        ),
      ),
    );
  }

  /// Zeigt die Liste der eigenen Flugzeuge an
  Widget _buildAircraftList() {
    return ListView.builder(
      itemCount: fleetManager.aircraftCount,
      itemBuilder: (context, index) {
        final aircraft = fleetManager.ownedAircraft[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.flight, size: 40, color: Colors.blue),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            aircraft.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "ID: ${aircraft.id} • ${aircraft.model}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildSpecItem(
                        "Reichweite",
                        "${aircraft.range} km",
                      ),
                    ),
                    Expanded(
                      child: _buildSpecItem(
                        "Kapazität",
                        "${aircraft.seatCapacity} Passagiere",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildSpecItem(
                        "Verbrauch",
                        "${aircraft.fuelConsumptionPerHour} L/h",
                      ),
                    ),
                    Expanded(
                      child: _buildSpecItem("Wert", aircraft.formattedPrice),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Zeigt den leeren Zustand an wenn keine Flugzeuge vorhanden sind
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flight, size: 80, color: Colors.grey[400]),
          SizedBox(height: 20),
          Text(
            "Noch keine Flugzeuge gekauft",
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 10),
          Text(
            "Kaufe dein erstes Flugzeug im Shop!",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  /// Hilfs-Widget für Spezifikations-Items
  Widget _buildSpecItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
