// lib/models/flugzeuge/a320_200.dart

import 'package:beyond_horizons/models/flugzeug.dart';

class A320_200 extends Flugzeug {
  A320_200()
    : super(
        name: "Airbus A320-200",
        modell: "A320-200",
        sitzkapazitaet: 180, // Standardkapazität für A320-200
        reichweite: 6000, // Reichweite in km
        verbrauchProStunde: 2500, // Verbrauch in Litern pro Stunde
      );
}
