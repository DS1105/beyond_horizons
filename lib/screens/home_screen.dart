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
import 'package:beyond_horizons/services/economy/airport_demand_calculator.dart';
import 'package:beyond_horizons/services/economy/monthly_load_calculator.dart';
import 'package:beyond_horizons/services/economy/route_cost_calculator.dart';
import 'package:beyond_horizons/services/economy/route_revenue_calculator.dart';
import 'package:beyond_horizons/services/economy/cashflow_calculator.dart';

/// Einfaches Dashboard für die Airline-Simulation
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Airline-Informationen aus dem globalen Manager
  String airlineName = AirlineManager().airlineName;

  // Spiel-Datum State (startet Januar 2025)
  // Diese Werte werden bei jedem "Nächster Monat" Klick aktualisiert
  int currentMonth = 1; // Januar
  int currentYear = 2025;

  // Monats-Namen für die deutsche Anzeige im UI
  // Index 0 = Januar, Index 11 = Dezember
  final List<String> monthNames = [
    'Januar',
    'Februar',
    'März',
    'April',
    'Mai',
    'Juni',
    'Juli',
    'August',
    'September',
    'Oktober',
    'November',
    'Dezember',
  ];

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
                          "${monthNames[currentMonth - 1]} $currentYear",
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
  /// 2. Routenauslastung berechnen
  /// 3. Kosten kalkulieren
  /// 4. Einnahmen kalkulieren
  /// 5. Cashflow zusammenfassen
  /// 6. Finanzen aktualisieren
  /// 7. Datum voranschreiten
  ///
  /// Aktuell werden nur Logs ausgegeben - die echte Simulation wird später implementiert
  void _advanceToNextMonth() {
    print("=== NÄCHSTER MONAT SIMULATION GESTARTET ===");

    // TODO: Hier werden später die Economy-Klassen aufgerufen:
    // Die auskommentierte Logik zeigt die geplante Struktur

    // 1. Airport Demand aktualisieren
    // Berechnet saisonale Schwankungen und Marktentwicklung für jeden Flughafen
    // final airportDemandCalculator = AirportDemandCalculator();
    // airportDemandCalculator.updateMonthlyDemand();
    print("1. Airport Demand Calculator - aktualisiere Flughafennachfrage");

    // 2. Monatliche Auslastung berechnen
    // Ermittelt Load Factor basierend auf Angebot vs. Nachfrage
    // final monthlyLoadCalculator = MonthlyLoadCalculator();
    // final loadFactors = monthlyLoadCalculator.calculateMonthlyLoads();
    print("2. Monthly Load Calculator - berechne Auslastungsfaktoren");

    // 3. Route-Kosten berechnen
    // Treibstoff, Gehälter, Wartung, Flughafengebühren etc.
    // final routeCostCalculator = RouteCostCalculator();
    // final totalCosts = routeCostCalculator.calculateMonthlyCosts();
    print("3. Route Cost Calculator - berechne Betriebskosten");

    // 4. Route-Einnahmen berechnen
    // Ticketverkäufe basierend auf Auslastung und Preisen
    // final routeRevenueCalculator = RouteRevenueCalculator();
    // final totalRevenue = routeRevenueCalculator.calculateMonthlyRevenue();
    print("4. Route Revenue Calculator - berechne Einnahmen");

    // 5. Cashflow aggregieren
    // Netto-Ergebnis: Einnahmen minus Kosten
    // final cashflowCalculator = CashflowCalculator();
    // final netCashflow = cashflowCalculator.calculateNetCashflow(totalRevenue, totalCosts);
    print("5. Cashflow Calculator - berechne Netto-Ergebnis");

    // 6. FinanceManager aktualisieren
    // Kapital der Airline anpassen (Gewinn/Verlust)
    // FinanceManager().addToCapital(netCashflow);
    print("6. Finance Manager - aktualisiere Kapital");

    // 7. Datum voranschreiten
    // UI-State aktualisieren: nächster Monat, ggf. nächstes Jahr
    setState(() {
      currentMonth++;
      if (currentMonth > 12) {
        currentMonth = 1;
        currentYear++;
      }
    });

    print(
      "7. Datum aktualisiert: ${monthNames[currentMonth - 1]} $currentYear",
    );
    print("=== SIMULATION ABGESCHLOSSEN ===");

    // Erfolgs-Snackbar anzeigen
    // Gibt dem Spieler visuelles Feedback über den Monatswechsel
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Monat ${monthNames[currentMonth - 1]} $currentYear erreicht!",
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
