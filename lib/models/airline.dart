/// Airline Klasse - repräsentiert eine Fluggesellschaft
class Airline {
  final String name; // Name der Airline
  final String registrationCountry; // Registrierungsland
  final double startCapital; // Startkapital in Euro (unveränderlich)

  double _currentCapital; // Aktuelles Kapital (privat, veränderbar)

  /// Konstruktor - erzeugt eine neue Airline
  Airline({
    required this.name,
    required this.registrationCountry,
    required this.startCapital,
  }) : _currentCapital = startCapital; // Aktuelles Kapital = Startkapital

  /// Getter für aktuelles Kapital
  double get currentCapital => _currentCapital;

  /// Geld hinzufügen (z.B. Einnahmen)
  void addMoney(double amount) {
    if (amount > 0) {
      _currentCapital += amount;
    }
  }

  /// Geld abziehen (z.B. Ausgaben)
  bool spendMoney(double amount) {
    if (amount > 0 && _currentCapital >= amount) {
      _currentCapital -= amount;
      return true; // Erfolg
    }
    return false; // Nicht genug Geld
  }

  /// toString für Debug-Ausgaben
  @override
  String toString() {
    return 'Airline: $name (${registrationCountry}) - Kapital: ${currentCapital.toStringAsFixed(2)}€ (Start: ${startCapital.toStringAsFixed(2)}€)';
  }
}

/* 
Verwendung:
- Diese Klasse kann verwendet werden, um eine Fluggesellschaft zu modellieren.
- Sie enthält grundlegende Informationen wie Name, Registrierungsland und Startkapital.
- Der Konstruktor stellt sicher, dass alle erforderlichen Felder beim Erstellen einer Instanz angegeben werden.

Beispiel:
var myAirline = Airline(
  name: "Lufthansa", 
  registrationCountry: "Deutschland",
  startCapital: 1000000.0
);

print(myAirline); // Zeigt alle Infos an
myAirline.addMoney(50000); // Geld hinzufügen
myAirline.spendMoney(30000); // Geld ausgeben
*/
