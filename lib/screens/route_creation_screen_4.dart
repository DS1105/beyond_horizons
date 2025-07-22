import 'package:flutter/material.dart';

/// Route Creation Screen 4
/// Service-Optionen auswählen
class RouteCreationScreen4 extends StatefulWidget {
  @override
  _RouteCreationScreen4State createState() => _RouteCreationScreen4State();
}

class _RouteCreationScreen4State extends State<RouteCreationScreen4> {
  // Service-Optionen
  bool kostenlosesEssen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Service auswählen"),
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
              "Service-Optionen",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            // Service-Auswahl
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.restaurant, color: Colors.orange),
                        SizedBox(width: 10),
                        Text(
                          "Bordservice",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    CheckboxListTile(
                      title: Text("Kostenloses Essen"),
                      subtitle: Text(
                        "Mahlzeiten für alle Passagiere inklusive",
                      ),
                      value: kostenlosesEssen,
                      onChanged: (bool? value) {
                        setState(() {
                          kostenlosesEssen = value ?? false;
                        });
                      },
                      secondary: Icon(Icons.fastfood),
                    ),
                  ],
                ),
              ),
            ),

            Spacer(),

            // Route erstellen Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Erfolgs-Nachricht anzeigen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Route erfolgreich erstellt!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Zurück zum Dashboard
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.green,
                ),
                child: Text(
                  "Route erstellen",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
