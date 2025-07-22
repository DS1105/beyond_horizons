import 'package:flutter/material.dart';

/// Screen für Routen-Übersicht und Verwaltung
class RoutesOverviewScreen extends StatefulWidget {
  @override
  _RoutesOverviewScreenState createState() => _RoutesOverviewScreenState();
}

class _RoutesOverviewScreenState extends State<RoutesOverviewScreen> {
  @override
  Widget build(BuildContext context) {
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

            // Placeholder für Routen-Liste
            Expanded(
              child: Center(
                child: Text(
                  "Noch keine Routen erstellt",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),

            // Button für neue Route
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Zur Route-Erstellung navigieren
              },
              child: Text("Neue Route erstellen"),
            ),
          ],
        ),
      ),
    );
  }
}
