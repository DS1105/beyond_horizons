import 'package:flutter/material.dart';
// Screen Imports - Navigation zu anderen Bereichen der App
import 'package:beyond_horizons/screens/aircraft_purchase_screen.dart';
import 'package:beyond_horizons/screens/routes_overview_screen.dart';
import 'package:beyond_horizons/screens/finance_screen.dart';
import 'package:beyond_horizons/screens/route_creation_screen_1.dart';
import 'package:beyond_horizons/screens/own_aircraft_screen.dart';
// Service Imports - Business Logic
import 'package:beyond_horizons/services/airline_manager.dart';
// Economy Simulation Imports - Monatliche Wirtschaftssimulation
import 'package:beyond_horizons/services/economy/economic_simulation_engine.dart';
import 'package:beyond_horizons/services/date_manager.dart';

/// Einfaches Dashboard für die Airline-Simulation
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Airline-Informationen aus dem globalen Manager
  String airlineName = AirlineManager().airlineName;

  // Use global DateManager instead of local date variables
  final DateManager _dateManager = DateManager();

  @override
  void initState() {
    super.initState();
    // Listen for date changes from other screens
    _dateManager.addListener(_onDateChanged);
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
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
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

            // === AIRLINE TITEL SEKTION ===
            Text(
              "${AirlineManager().airlineName} Management",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            // === NAVIGATION BUTTONS SEKTION ===
            // Alle Haupt-Features der App als Dashboard-Karten

            // Button 1: Neue Route erstellen
            _buildDashboardButton(
              icon: Icons.flight_takeoff,
              title: "Route anlegen",
              subtitle: "Neue Flugverbindung erstellen",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RouteCreationScreen1(),
                  ),
                );
              },
            ),
            SizedBox(height: 15),

            // Button 2: Bestehende Routen verwalten
            _buildDashboardButton(
              icon: Icons.list,
              title: "Routen anzeigen",
              subtitle: "Alle Verbindungen verwalten",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoutesOverviewScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 15),

            // Button 3: Flotte erweitern
            _buildDashboardButton(
              icon: Icons.shopping_cart,
              title: "Flugzeuge kaufen",
              subtitle: "Flotte erweitern",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AircraftPurchaseScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 15),

            // Button 4: Flotte verwalten
            _buildDashboardButton(
              icon: Icons.flight,
              title: "Eigene Flugzeuge",
              subtitle: "Flotte anzeigen und verwalten",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OwnAircraftScreen()),
                );
              },
            ),
            SizedBox(height: 15),

            // Button 5: Finanzübersicht
            _buildDashboardButton(
              icon: Icons.account_balance,
              title: "Finanzen",
              subtitle: "Kapital und Gewinn verwalten",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FinanceScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Hilfs-Widget für Dashboard-Buttons
  /// Erstellt einheitliche Karten mit Icon, Titel, Untertitel und Navigation
  ///
  /// @param icon - Material Icon für die Karte
  /// @param title - Haupttext der Karte
  /// @param subtitle - Beschreibungstext
  /// @param onPressed - Callback für Button-Klick (meist Navigation)
  Widget _buildDashboardButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.blue),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onPressed,
      ),
    );
  }

  /// Methode zum Voranschreiten zum nächsten Monat
  /// Führt die komplette Wirtschaftssimulation aus
  ///
  /// Diese Methode orchestriert den gesamten monatlichen Simulationszyklus:
  /// 1. Flughafennachfrage aktualisieren
  /// 2. Routenauslastung berechnen (FUNKTIONSFÄHIG!)
  /// 3. Kosten kalkulieren
  /// 4. Einnahmen kalkulieren
  /// 5. Cashflow zusammenfassen
  /// 6. Finanzen aktualisieren
  /// 7. Datum voranschreiten
  void _advanceToNextMonth() async {
    print("=== NÄCHSTER MONAT SIMULATION GESTARTET ===");

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
        content: Text("Monat ${_dateManager.getFormattedDate()} erreicht!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
