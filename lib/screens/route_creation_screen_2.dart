import 'package:flutter/material.dart';
import 'package:beyond_horizons/screens/route_creation_screen_3.dart';

/// Route Creation Screen 2
/// Flugzeug-Auswahl für die Route
class RouteCreationScreen2 extends StatefulWidget {
  @override
  _RouteCreationScreen2State createState() => _RouteCreationScreen2State();
}

class _RouteCreationScreen2State extends State<RouteCreationScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flugzeug wählen"),
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
              "Flugzeug-Auswahl",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text("Hier wird später die Flugzeug-Auswahl implementiert."),

            Spacer(),

            // Weiter Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RouteCreationScreen3(),
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
