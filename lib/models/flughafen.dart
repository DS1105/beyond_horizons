class Flughafen {
  String name;
  String land;
  String city;
  int slotKapazitaet; // Gesamt-Kapazität der Slots (Takeoff/Landing)
  int aktuelleSlotNutzung; // Aktuell genutzte Kapazität für Slots
  int terminalKapazitaet; // Gesamt-Kapazität des Terminals
  int aktuelleTerminalNutzung; // Aktuell genutzte Kapazität für Terminals
  int maxKapazitaet; // Maximale Kapazität für den Flughafen insgesamt
  bool genehmigungErteilt; // Ob eine Genehmigung für den Ausbau vorliegt

  Flughafen({
    required this.name,
    required this.land,
    required this.city,
    required this.slotKapazitaet,
    required this.aktuelleSlotNutzung,
    required this.terminalKapazitaet,
    required this.aktuelleTerminalNutzung,
    required this.maxKapazitaet,
    this.genehmigungErteilt = false, // Standardmäßig keine Genehmigung
  });

  // Getter für verfügbare Kapazität der Slots
  int get verfuegbareSlotKapazitaet {
    return slotKapazitaet - aktuelleSlotNutzung;
  }

  int get kapazitaet {
    return slotKapazitaet + terminalKapazitaet;
  }

  // Getter für verfügbare Kapazität des Terminals
  int get verfuegbareTerminalKapazitaet {
    return terminalKapazitaet - aktuelleTerminalNutzung;
  }

  // Getter für die gesamte verfügbare Kapazität (Slots + Terminal)
  int get verfuegbareGesamtKapazitaet {
    return verfuegbareSlotKapazitaet + verfuegbareTerminalKapazitaet;
  }

  // Methode zum Überprüfen, ob die Kapazität ausreicht
  bool checkKapazitaet() {
    return (aktuelleSlotNutzung < slotKapazitaet) &&
        (aktuelleTerminalNutzung < terminalKapazitaet);
  }

  // Methode zum Ausbauen des Flughafens
  void ausbauen(String ausbauart) {
    if (genehmigungErteilt) {
      if (ausbauart == 'Passagierterminal') {
        terminalKapazitaet +=
            1000000; // Beispiel: Kapazität wird um 1 Million erhöht
      } else if (ausbauart == 'Frachtterminal') {
        slotKapazitaet += 500000; // Beispiel: Kapazität wird um 500.000 erhöht
      }
      print('Der Flughafen wurde um ein $ausbauart ausgebaut.');
    } else {
      print('Ausbau nicht möglich. Genehmigung erforderlich.');
    }
  }

  // Methode zur Erteilung einer Genehmigung
  void genehmigungErteilen() {
    genehmigungErteilt = true;
    print('Genehmigung für den Ausbau erteilt.');
  }
}
