import 'package:flutter/material.dart';
import 'package:beyond_horizons/services/route_manager.dart';
import 'package:beyond_horizons/models/route.dart' as RouteModel;
import 'package:beyond_horizons/screens/route_creation_screen_1.dart';
import 'package:beyond_horizons/services/economy/economic_simulation_engine.dart';
import 'package:beyond_horizons/services/economy/monthly_load_calculator.dart';
import 'package:beyond_horizons/services/date_manager.dart';

/// Screen für Routen-Übersicht und Verwaltung
class RoutesOverviewScreen extends StatefulWidget {
  @override
  _RoutesOverviewScreenState createState() => _RoutesOverviewScreenState();
}

class _RoutesOverviewScreenState extends State<RoutesOverviewScreen> {
  // Use global DateManager instead of local date variables
  final DateManager _dateManager = DateManager();

  @override
  void initState() {
    super.initState();
    // Listen for date changes from other screens
    _dateManager.addListener(_onDateChanged);
    // Trigger UI refresh when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Remove listener to prevent memory leaks
    _dateManager.removeListener(_onDateChanged);
    super.dispose();
  }

  /// Called when date changes in any screen
  void _onDateChanged() {
    setState(() {
      // Trigger UI rebuild to show new date
    });
  }

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
            // === DATUM UND SIMULATION SEKTION ===
            // Zeigt aktuelles Spieldatum und "Nächster Monat" Button
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Linke Seite: Datum-Anzeige
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Aktueller Monat:",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          _dateManager.getFormattedDate(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Rechte Seite: Simulation-Button
                    ElevatedButton.icon(
                      icon: Icon(Icons.fast_forward),
                      label: Text("Nächster Monat"),
                      onPressed: _advanceToNextMonth,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

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

              SizedBox(height: 12),

              // Auslastung pro Sitzklasse
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Aktuelle Auslastung:",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 4),
                    _buildLoadFactorRow(
                      "Economy",
                      _getEconomyLoadFactor(route),
                    ),
                    _buildLoadFactorRow(
                      "Business",
                      _getBusinessLoadFactor(route),
                    ),
                    _buildLoadFactorRow("First", _getFirstLoadFactor(route)),
                  ],
                ),
              ),

              SizedBox(height: 8),

              // Monatliche Einnahmen
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Monatliche Einnahmen:",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[700],
                      ),
                    ),
                    Text(
                      "${_getMonthlyRevenue(route)} USD",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                  ],
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

  /// Hilfsmethode für Load Factor Zeilen
  Widget _buildLoadFactorRow(String className, double loadFactor) {
    Color color = _getLoadFactorColor(loadFactor);

    return Padding(
      padding: EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            className,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              "${(loadFactor * 100).toStringAsFixed(1)}%",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Hilfsmethode für Load Factor Farben
  Color _getLoadFactorColor(double loadFactor) {
    if (loadFactor >= 0.8) return Colors.green;
    if (loadFactor >= 0.6) return Colors.orange;
    return Colors.red;
  }

  // === LOAD FACTOR BERECHNUNGEN - NUTZT ECHTE SIMULATION ===

  /// Berechnet aktuelle Economy Load Factor für eine Route
  double _getEconomyLoadFactor(RouteModel.Route route) {
    // Nutze die echte MonthlyLoadCalculator Logik
    MonthlyLoadCalculator calculator = MonthlyLoadCalculator();
    List<LoadFactorResult> results = calculator.calculateMonthlyLoads();

    // Finde die passende Route in den Ergebnissen
    LoadFactorResult? routeResult;
    try {
      routeResult = results.firstWhere((result) => result.routeId == route.id);
      return routeResult.economyLoadFactor;
    } catch (e) {
      // Fallback: Route nicht gefunden, nutze Placeholder
      return 0.6 + (route.id! * 0.03) % 0.3;
    }
  }

  /// Berechnet aktuelle Business Load Factor für eine Route
  double _getBusinessLoadFactor(RouteModel.Route route) {
    // Nutze die echte MonthlyLoadCalculator Logik
    MonthlyLoadCalculator calculator = MonthlyLoadCalculator();
    List<LoadFactorResult> results = calculator.calculateMonthlyLoads();

    // Finde die passende Route in den Ergebnissen
    LoadFactorResult? routeResult;
    try {
      routeResult = results.firstWhere((result) => result.routeId == route.id);
      return routeResult.businessLoadFactor;
    } catch (e) {
      // Fallback: Route nicht gefunden, nutze Placeholder
      return 0.4 + (route.id! * 0.05) % 0.3;
    }
  }

  /// Berechnet aktuelle First Load Factor für eine Route
  double _getFirstLoadFactor(RouteModel.Route route) {
    // Nutze die echte MonthlyLoadCalculator Logik
    MonthlyLoadCalculator calculator = MonthlyLoadCalculator();
    List<LoadFactorResult> results = calculator.calculateMonthlyLoads();

    // Finde die passende Route in den Ergebnissen
    LoadFactorResult? routeResult;
    try {
      routeResult = results.firstWhere((result) => result.routeId == route.id);
      return routeResult.firstLoadFactor;
    } catch (e) {
      // Fallback: Route nicht gefunden, nutze Placeholder
      return 0.2 + (route.id! * 0.07) % 0.3;
    }
  }

  /// TODO: Ersetzen mit echter Einnahmen-Berechnung
  String _getMonthlyRevenue(RouteModel.Route route) {
    // Placeholder: Simuliere Einnahmen basierend auf Route ID und Kapazität
    int baseRevenue = (route.id! * 50000) + (route.aircraftCount * 25000);
    return baseRevenue.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// Methode zum Voranschreiten zum nächsten Monat
  /// Führt die komplette Wirtschaftssimulation aus (gleich wie HomeScreen)
  void _advanceToNextMonth() async {
    print("=== NÄCHSTER MONAT SIMULATION GESTARTET (Routen-Screen) ===");

    try {
      // ECHTE SIMULATION: EconomicSimulationEngine verwenden
      final simulationEngine = EconomicSimulationEngine();

      // 1. Airport Demand aktualisieren (noch nicht implementiert)
      print("1. Airport Demand Calculator - aktualisiere Flughafennachfrage");

      // 2. FUNKTIONSFÄHIG: Monatliche Auslastung berechnen
      await simulationEngine.step2_CalculateRouteLoads();

      // Debug: Zeige Load Factor Ergebnisse
      final loadFactors = simulationEngine.getCurrentLoadFactors();
      if (loadFactors != null && loadFactors.isNotEmpty) {
        print("   📊 Detaillierte Load Factors:");
        for (var result in loadFactors) {
          print("      ${result.toString()}");
        }
      }

      // 3-6. Noch nicht implementiert - placeholder logs
      print("3. Route Cost Calculator - berechne Betriebskosten");
      print("4. Route Revenue Calculator - berechne Einnahmen");
      print("5. Cashflow Calculator - berechne Netto-Ergebnis");
      print("6. Finance Manager - aktualisiere Kapital");
    } catch (e) {
      print("❌ Fehler während der Simulation: $e");
      // Weiter mit Datum-Update trotz Fehler
    }

    // 7. Datum voranschreiten (funktioniert immer)
    setState(() {
      _dateManager.advanceToNextMonth();
    });

    print("7. Datum aktualisiert: ${_dateManager.getFormattedDate()}");
    print("=== SIMULATION ABGESCHLOSSEN ===");

    // Erfolgs-Snackbar anzeigen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Monat ${_dateManager.getFormattedDate()} erreicht! Load Factors aktualisiert.",
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
