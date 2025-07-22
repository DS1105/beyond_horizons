import 'package:flutter/material.dart';
import 'package:beyond_horizons/screens/route_creation_screen_4.dart';

/// Route Creation Screen 3
/// Flüge pro Woche festlegen
class RouteCreationScreen3 extends StatefulWidget {
  @override
  _RouteCreationScreen3State createState() => _RouteCreationScreen3State();
}

class _RouteCreationScreen3State extends State<RouteCreationScreen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flüge pro Woche"),
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
            // Placeholder Content
            Text(
              "Flugfrequenz festlegen",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Hier wird später die Auswahl der Flüge pro Woche implementiert.",
            ),

            Spacer(),

            // Weiter Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RouteCreationScreen4(),
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
}
