import 'package:flutter/material.dart';
import 'package:beyond_horizons/models/aircraft.dart';
import 'package:beyond_horizons/models/aircraft_types/a320_200.dart';
import 'package:beyond_horizons/services/finance_manager.dart';
import 'package:beyond_horizons/services/fleet_manager.dart';

/// Screen für den Kauf von Flugzeugen
/// Zeigt alle verfügbaren Flugzeugtypen mit Details an
class AircraftPurchaseScreen extends StatefulWidget {
  @override
  _AircraftPurchaseScreenState createState() => _AircraftPurchaseScreenState();
}

class _AircraftPurchaseScreenState extends State<AircraftPurchaseScreen> {
  final FinanceManager financeManager = FinanceManager();
  final FleetManager fleetManager = FleetManager();

  /// Liste aller verfügbaren Flugzeugtypen
  /// Verwendet Templates um ID-Verschwendung zu vermeiden
  List<Aircraft> get availableAircraft => [
    A320_200.template,
    // Hier können später weitere Flugzeugtypen hinzugefügt werden
  ];

  /// Kauft ein Flugzeug wenn genug Kapital vorhanden ist
  void _purchaseAircraft(Aircraft template) {
    if (financeManager.removeCapital(template.purchasePrice)) {
      // Neue Instanz basierend auf Template erstellen
      Aircraft newAircraft = _createAircraftFromTemplate(template);

      // Flugzeug zur eigenen Flotte hinzufügen
      fleetManager.addAircraft(newAircraft);

      setState(() {
        // UI aktualisieren
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${template.name} erfolgreich gekauft! (ID: ${newAircraft.id})",
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Nicht genug Kapital für ${template.name}!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Erstellt eine neue Flugzeug-Instanz basierend auf einem Template
  Aircraft _createAircraftFromTemplate(Aircraft template) {
    if (template.model == "A320-200") {
      return A320_200();
    }
    // Fallback für unbekannte Typen - sollte erweitert werden
    return A320_200();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flugzeuge kaufen")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kapital-Anzeige
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.account_balance_wallet, color: Colors.green),
                    SizedBox(width: 10),
                    Text(
                      "Verfügbares Kapital: ",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      financeManager.formattedCapital,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Titel
            Text(
              "Verfügbare Flugzeuge",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Flugzeugliste
            Expanded(
              child: ListView.builder(
                itemCount: availableAircraft.length,
                itemBuilder: (context, index) {
                  final aircraft = availableAircraft[index];
                  final canAfford =
                      financeManager.currentCapital >= aircraft.purchasePrice;

                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: _buildAircraftCard(aircraft, canAfford),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Erstellt eine Card für ein Flugzeug (ähnlich HomeScreen)
  Widget _buildAircraftCard(Aircraft aircraft, bool canAfford) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flugzeug-Header
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
                        aircraft.model,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Spezifikationen
            Row(
              children: [
                Expanded(
                  child: _buildSpecItem("Reichweite", "${aircraft.range} km"),
                ),
                Expanded(
                  child: _buildSpecItem(
                    "Verbrauch",
                    "${aircraft.fuelConsumptionPerHour} L/h",
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildSpecItem(
                    "Kapazität",
                    "${aircraft.seatCapacity} Passagiere",
                  ),
                ),
                Expanded(
                  child: _buildSpecItem("Preis", aircraft.formattedPrice),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Kaufen-Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canAfford ? () => _purchaseAircraft(aircraft) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAfford ? Colors.blue : Colors.grey,
                ),
                child: Text(
                  canAfford ? "Kaufen" : "Nicht genug Kapital",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
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
