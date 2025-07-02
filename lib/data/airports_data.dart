/// Central data repository for all airports in the simulation
/// Organized by regions and cities for better scalability
import 'package:beyond_horizons/models/airport.dart';

/// Static class containing all airport data organized by regions
class AirportsData {
  /// All airports organized by continent -> country -> city
  static final Map<String, Map<String, Map<String, List<Airport>>>>
  _airportsByRegion = {
    'Europe': {
      'Germany': {
        'Frankfurt': [
          Airport(
            name: "Frankfurt Airport",
            iataCode: "FRA",
            icaoCode: "EDDF",
            country: "Germany",
            city: "Frankfurt",
            region: "Europe",
            slotCapacity: 500000,
            currentSlotUsage: 300000,
            terminalCapacity: 200000,
            currentTerminalUsage: 150000,
            maxCapacity: 800000,
            latitude: 50.0379,
            longitude: 8.5622,
            isHub: true,
            hubLevel: 5, // International hub
          ),
        ],
        'Munich': [
          Airport(
            name: "Munich Airport",
            iataCode: "MUC",
            icaoCode: "EDDM",
            country: "Germany",
            city: "Munich",
            region: "Europe",
            slotCapacity: 400000,
            currentSlotUsage: 150000,
            terminalCapacity: 100000,
            currentTerminalUsage: 50000,
            maxCapacity: 600000,
            latitude: 48.3537,
            longitude: 11.7750,
            isHub: true,
            hubLevel: 4,
          ),
        ],
        'Berlin': [
          Airport(
            name: "Berlin Brandenburg Airport",
            iataCode: "BER",
            icaoCode: "EDDB",
            country: "Germany",
            city: "Berlin",
            region: "Europe",
            slotCapacity: 300000,
            currentSlotUsage: 200000,
            terminalCapacity: 150000,
            currentTerminalUsage: 120000,
            maxCapacity: 500000,
            latitude: 52.3667,
            longitude: 13.5033,
            isHub: false,
            hubLevel: 3,
          ),
        ],
        'Hamburg': [
          Airport(
            name: "Hamburg Airport",
            iataCode: "HAM",
            icaoCode: "EDDH",
            country: "Germany",
            city: "Hamburg",
            region: "Europe",
            slotCapacity: 200000,
            currentSlotUsage: 100000,
            terminalCapacity: 80000,
            currentTerminalUsage: 60000,
            maxCapacity: 300000,
            latitude: 53.6304,
            longitude: 9.9882,
            isHub: false,
            hubLevel: 2,
          ),
        ],
        'Cologne': [
          Airport(
            name: "Cologne Bonn Airport",
            iataCode: "CGN",
            icaoCode: "EDDK",
            country: "Germany",
            city: "Cologne",
            region: "Europe",
            slotCapacity: 180000,
            currentSlotUsage: 90000,
            terminalCapacity: 70000,
            currentTerminalUsage: 50000,
            maxCapacity: 250000,
            latitude: 50.8659,
            longitude: 7.1427,
            isHub: false,
            hubLevel: 2,
          ),
        ],
      },
    },
  };

  /// Get all airports as a flat list
  static List<Airport> getAllAirports() {
    List<Airport> allAirports = [];
    _airportsByRegion.forEach((region, countries) {
      countries.forEach((country, cities) {
        cities.forEach((city, airports) {
          allAirports.addAll(airports);
        });
      });
    });
    return allAirports;
  }

  /// Get airports by region
  static List<Airport> getAirportsByRegion(String region) {
    List<Airport> airports = [];
    if (_airportsByRegion.containsKey(region)) {
      _airportsByRegion[region]!.forEach((country, cities) {
        cities.forEach((city, airportList) {
          airports.addAll(airportList);
        });
      });
    }
    return airports;
  }

  /// Get airports by country
  static List<Airport> getAirportsByCountry(String country) {
    List<Airport> airports = [];
    _airportsByRegion.forEach((region, countries) {
      if (countries.containsKey(country)) {
        countries[country]!.forEach((city, airportList) {
          airports.addAll(airportList);
        });
      }
    });
    return airports;
  }

  /// Get airports by city
  static List<Airport> getAirportsByCity(String city) {
    List<Airport> airports = [];
    _airportsByRegion.forEach((region, countries) {
      countries.forEach((country, cities) {
        if (cities.containsKey(city)) {
          airports.addAll(cities[city]!);
        }
      });
    });
    return airports;
  }

  /// Search airports by name, IATA, ICAO, city, or country
  static List<Airport> searchAirports(String query) {
    if (query.isEmpty) return getAllAirports();

    String lowercaseQuery = query.toLowerCase();
    return getAllAirports().where((airport) {
      return airport.name.toLowerCase().contains(lowercaseQuery) ||
          airport.city.toLowerCase().contains(lowercaseQuery) ||
          airport.country.toLowerCase().contains(lowercaseQuery) ||
          airport.iataCode.toLowerCase().contains(lowercaseQuery) ||
          airport.icaoCode.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Get hub airports only
  static List<Airport> getHubAirports() {
    return getAllAirports().where((airport) => airport.isHub).toList();
  }

  /// Get airports by hub level (1-5, where 5 is major international hub)
  static List<Airport> getAirportsByHubLevel(int minLevel) {
    return getAllAirports()
        .where((airport) => airport.hubLevel >= minLevel)
        .toList();
  }

  /// Get all regions
  static List<String> getAllRegions() {
    return _airportsByRegion.keys.toList();
  }

  /// Get countries in a region
  static List<String> getCountriesInRegion(String region) {
    if (_airportsByRegion.containsKey(region)) {
      return _airportsByRegion[region]!.keys.toList();
    }
    return [];
  }

  /// Get cities in a country
  static List<String> getCitiesInCountry(String country) {
    List<String> cities = [];
    _airportsByRegion.forEach((region, countries) {
      if (countries.containsKey(country)) {
        cities.addAll(countries[country]!.keys);
      }
    });
    return cities;
  }

  /// Get the raw airport data structure for service integration
  static Map<String, Map<String, Map<String, List<Airport>>>>
  getAirportsByRegionMap() {
    return Map.from(_airportsByRegion);
  }
}
