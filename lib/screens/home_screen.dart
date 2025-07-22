import 'package:flutter/material.dart';
import 'package:beyond_horizons/screens/aircraft_purchase_screen.dart';
import 'package:beyond_horizons/screens/routes_overview_screen.dart';
import 'package:beyond_horizons/screens/finance_screen.dart';
import 'package:beyond_horizons/screens/route_creation_screen_1.dart';
import 'package:beyond_horizons/screens/own_aircraft_screen.dart';
import 'package:beyond_horizons/services/airline_manager.dart';

/// Einfaches Dashboard für die Airline-Simulation
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String airlineName = AirlineManager().airlineName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titel
            Text(
              "${AirlineManager().airlineName} Management",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            // Dashboard-Buttons
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
}
