/// Manager für alle Finanz-Operationen der Airline
/// Verwaltet Kapital, Einnahmen, Ausgaben und bietet Formatierungsmethoden
class FinanceManager {
  static final FinanceManager _instance = FinanceManager._internal();
  factory FinanceManager() => _instance;
  FinanceManager._internal();

  // Aktuelles Kapital in USD
  int _currentCapital = 0; // Wird beim Spielstart gesetzt

  // Gibt an, ob das Spiel bereits initialisiert wurde
  bool _isInitialized = false;

  // Getter für aktuelles Kapital
  int get currentCapital => _currentCapital;

  // Getter für Initialisierungsstatus
  bool get isInitialized => _isInitialized;

  /// Initialisiert das Spiel mit Startkapital
  /// Kann nur einmal aufgerufen werden
  void initializeGame(int startCapital) {
    if (!_isInitialized) {
      _currentCapital = startCapital;
      _isInitialized = true;
    }
  }

  /// Setzt das Spiel zurück (für Neustart)
  void resetGame() {
    _currentCapital = 0;
    _isInitialized = false;
  }

  /// Kapital erhöhen (z.B. durch Einnahmen)
  void addCapital(int amount) {
    _currentCapital += amount;
  }

  /// Kapital reduzieren (z.B. durch Ausgaben)
  /// Gibt true zurück wenn genug Kapital vorhanden war, false wenn nicht
  bool removeCapital(int amount) {
    if (_currentCapital >= amount) {
      _currentCapital -= amount;
      return true;
    }
    return false;
  }

  /// Kapital direkt setzen
  void setCapital(int amount) {
    _currentCapital = amount;
  }

  /// Formatiert einen Geldbetrag für die UI-Anzeige
  /// Verwendet dieselbe Logik wie Aircraft.formattedPrice aber mit USD
  String formatCurrency(int amount) {
    if (amount >= 1000000) {
      double millions = amount / 1000000;
      if (millions == millions.round()) {
        return "${millions.round()} Mio. USD";
      } else {
        return "${millions.toStringAsFixed(1).replaceAll('.', ',')} Mio. USD";
      }
    } else {
      return "${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} USD";
    }
  }

  /// Formatiertes aktuelles Kapital
  String get formattedCapital => formatCurrency(_currentCapital);
}
