import 'package:flutter/material.dart';
import 'package:beyond_horizons/screens/route_creation_screen_4.dart';
import 'package:beyond_horizons/models/route.dart' as RouteModel;

/// Route Creation Screen 3
/// Fluganzahl pro Woche festlegen
class RouteCreationScreen3 extends StatefulWidget {
  final RouteModel.Route route; // Temporary route from previous screen

  const RouteCreationScreen3({Key? key, required this.route}) : super(key: key);

  @override
  _RouteCreationScreen3State createState() => _RouteCreationScreen3State();
}

class _RouteCreationScreen3State extends State<RouteCreationScreen3> {
  int selectedFlights = 1;
  late int maxFlights;

  @override
  void initState() {
    super.initState();
    // Berechne maximale Flüge basierend auf allen Flugzeugen
    maxFlights = _calculateMaxFlightsForAllAircraft();
    selectedFlights = 1;
  }

  /// Berechnet die maximalen Flüge pro Woche für alle Flugzeuge zusammen
  int _calculateMaxFlightsForAllAircraft() {
    if (widget.route.aircraft.isEmpty) {
      // Fallback: Verwende selectedAircraft falls aircraft-Liste leer ist
      return widget.route.selectedAircraft?.calculateMaxFlightsPerWeek(
            widget.route.distanceKm,
          ) ??
          1;
    }

    int totalMaxFlights = 0;
    for (var aircraft in widget.route.aircraft) {
      totalMaxFlights += aircraft.calculateMaxFlightsPerWeek(
        widget.route.distanceKm,
      );
    }
    return totalMaxFlights;
  }

  /// Berechnet Durchschnittswerte für die Anzeige (basierend auf allen Flugzeugen)
  double get averageFlightTimeOneWay {
    if (widget.route.aircraft.isEmpty) {
      return widget.route.distanceKm /
          (widget.route.selectedAircraft?.cruiseSpeed ?? 800);
    }

    double totalTime = 0;
    for (var aircraft in widget.route.aircraft) {
      totalTime += widget.route.distanceKm / aircraft.cruiseSpeed;
    }
    return totalTime / widget.route.aircraft.length;
  }

  double get averageTotalFlightTime =>
      averageFlightTimeOneWay * 2; // Round trip

  double get averageTurnaroundTime {
    if (widget.route.aircraft.isEmpty) {
      return ((widget.route.selectedAircraft?.turnaroundTimeMinutes ?? 30) *
              2) /
          60;
    }

    double totalTurnaround = 0;
    for (var aircraft in widget.route.aircraft) {
      totalTurnaround += (aircraft.turnaroundTimeMinutes * 2) / 60;
    }
    return totalTurnaround / widget.route.aircraft.length;
  }

  double get totalTaxiTime => (10 * 4) / 60; // 4 taxi operations per round trip
  double get averageTimePerRoundTrip =>
      averageTotalFlightTime + averageTurnaroundTime + totalTaxiTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flugfrequenz festlegen"),
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
            // Route und Flugzeug Info
            _buildRouteAircraftInfo(),
            SizedBox(height: 24),

            // Zeiten-Breakdown
            _buildTimeBreakdown(),
            SizedBox(height: 24),

            // Fluganzahl-Auswahl
            _buildFlightSelection(),
            SizedBox(height: 24),

            // Zusammenfassung
            _buildSummary(),

            Spacer(),

            // Weiter Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Save selected flights per week to route
                  widget.route.flightsPerWeek = selectedFlights;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => RouteCreationScreen4(
                            route: widget.route, // Pass route to final screen
                          ),
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
    );
  }

  Widget _buildRouteAircraftInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Route & Flugzeug",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.flight_takeoff, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  "${widget.route.startAirport!.iataCode} → ${widget.route.endAirport!.iataCode}",
                ),
                Spacer(),
                Text("${widget.route.distanceKm} km"),
              ],
            ),
            SizedBox(height: 8),

            // Flugzeuge anzeigen
            if (widget.route.aircraft.isNotEmpty) ...[
              Row(
                children: [
                  Icon(Icons.airplanemode_active, color: Colors.green),
                  SizedBox(width: 8),
                  Text("${widget.route.aircraft.length} Flugzeug(e):"),
                ],
              ),
              SizedBox(height: 4),
              ...widget.route.aircraft
                  .map(
                    (aircraft) => Padding(
                      padding: EdgeInsets.only(left: 32, bottom: 2),
                      child: Text(
                        "• ${aircraft.name} (ID: ${aircraft.id})",
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ),
                  )
                  .toList(),
            ] else if (widget.route.selectedAircraft != null) ...[
              // Fallback für Backward Compatibility
              Row(
                children: [
                  Icon(Icons.airplanemode_active, color: Colors.green),
                  SizedBox(width: 8),
                  Text("${widget.route.selectedAircraft!.name}"),
                  Spacer(),
                  Text("ID: ${widget.route.selectedAircraft!.id}"),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBreakdown() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Zeiten-Analyse",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            _buildTimeRow(
              "Flugzeit (einfach) ⌀",
              "${averageFlightTimeOneWay.toStringAsFixed(1)}h",
            ),
            _buildTimeRow(
              "Flugzeit (Rundflug) ⌀",
              "${averageTotalFlightTime.toStringAsFixed(1)}h",
            ),
            _buildTimeRow(
              "Turnaround (2x) ⌀",
              "${averageTurnaroundTime.toStringAsFixed(1)}h",
            ),
            _buildTimeRow(
              "Taxi-Zeiten (4x)",
              "${totalTaxiTime.toStringAsFixed(1)}h",
            ),
            Divider(),
            _buildTimeRow(
              "Gesamt pro Rundflug ⌀",
              "${averageTimePerRoundTrip.toStringAsFixed(1)}h",
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRow(String label, String time, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.blue : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightSelection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Flüge pro Woche",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Gewählte Anzahl: $selectedFlights Flug${selectedFlights != 1 ? 'e' : ''} pro Woche",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 12),
            Slider(
              min: 1,
              max: maxFlights.toDouble(),
              divisions: maxFlights > 1 ? maxFlights - 1 : 1,
              value: selectedFlights.toDouble(),
              onChanged: (value) {
                setState(() {
                  selectedFlights = value.round();
                });
              },
              label: selectedFlights.toString(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("1", style: TextStyle(color: Colors.grey[600])),
                Text(
                  "Maximum: $maxFlights",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    double totalOperatingTime = averageTimePerRoundTrip * selectedFlights;
    double averageFlightsPerDay = selectedFlights / 7.0;

    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Zusammenfassung",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            _buildSummaryRow("Flüge pro Woche", "$selectedFlights"),
            _buildSummaryRow(
              "Flüge pro Tag (Ø)",
              "${averageFlightsPerDay.toStringAsFixed(1)}",
            ),
            _buildSummaryRow(
              "Betriebszeit/Woche",
              "${totalOperatingTime.toStringAsFixed(1)}h",
            ),
            _buildSummaryRow(
              "Wochenauslastung",
              "${(totalOperatingTime / 112 * 100).toStringAsFixed(0)}%",
            ),
            if (selectedFlights > 1)
              _buildSummaryRow(
                "Flugintervall (Ø)",
                "${(112 / selectedFlights).toStringAsFixed(1)}h",
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }
}
