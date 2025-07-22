import 'package:beyond_horizons/models/aircraft_types/a320_200.dart';

void main() {
  // Test der Preisformatierung
  var a320 = A320_200();
  print("A320-200 Preis: ${a320.formattedPrice}");

  // Weitere Testfälle für die Formatierung:
  // 110.000.000 → "110 Mio. USD"
  // 1.500.000 → "1,5 Mio. USD"
  // 500.000 → "500.000 USD"
  // 50.000 → "50.000 USD"
}
