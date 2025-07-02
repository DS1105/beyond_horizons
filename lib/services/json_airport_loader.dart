/// JSON-based airport data loader for scalable airport management
/// Loads airport data from external JSON files instead of hardcoded data
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:beyond_horizons/models/airport.dart';

/// Service class for loading airports from JSON files
/// Supports both local assets and future network-based data sources
class JsonAirportLoader {
  static Map<String, Map<String, Map<String, List<Airport>>>>? _cachedAirports;
  static bool _isLoaded = false;

  /// Load airports from JSON asset file
  /// Returns the hierarchical airport structure: Region -> Country -> City -> Airports
  static Future<Map<String, Map<String, Map<String, List<Airport>>>>>
  loadAirports() async {
    if (_isLoaded && _cachedAirports != null) {
      return _cachedAirports!;
    }

    try {
      // Load JSON file from assets
      final String jsonString = await rootBundle.loadString(
        'assets/data/airports.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Parse JSON structure
      final Map<String, Map<String, Map<String, List<Airport>>>>
      airportsByRegion = {};

      final Map<String, dynamic> airportsData = jsonData['airports'];

      airportsData.forEach((regionName, regionData) {
        final Map<String, Map<String, List<Airport>>> countries = {};

        (regionData as Map<String, dynamic>).forEach((
          countryName,
          countryData,
        ) {
          final Map<String, List<Airport>> cities = {};

          (countryData as Map<String, dynamic>).forEach((
            cityName,
            cityAirports,
          ) {
            final List<Airport> airports = [];

            (cityAirports as List<dynamic>).forEach((airportJson) {
              airports.add(Airport.fromJson(airportJson));
            });

            cities[cityName] = airports;
          });

          countries[countryName] = cities;
        });

        airportsByRegion[regionName] = countries;
      });

      _cachedAirports = airportsByRegion;
      _isLoaded = true;

      return airportsByRegion;
    } catch (e) {
      print('Error loading airports from JSON: $e');
      // Fallback to hardcoded data if JSON loading fails
      return _getFallbackAirports();
    }
  }

  /// Get all airports as a flat list from JSON data
  static Future<List<Airport>> getAllAirports() async {
    final airportsByRegion = await loadAirports();

    List<Airport> allAirports = [];
    airportsByRegion.forEach((region, countries) {
      countries.forEach((country, cities) {
        cities.forEach((city, airports) {
          allAirports.addAll(airports);
        });
      });
    });

    return allAirports;
  }

  /// Search airports by various criteria from JSON data
  static Future<List<Airport>> searchAirports(String query) async {
    if (query.isEmpty) return await getAllAirports();

    final allAirports = await getAllAirports();
    String lowercaseQuery = query.toLowerCase();

    return allAirports.where((airport) {
      return airport.name.toLowerCase().contains(lowercaseQuery) ||
          airport.city.toLowerCase().contains(lowercaseQuery) ||
          airport.country.toLowerCase().contains(lowercaseQuery) ||
          airport.iataCode.toLowerCase().contains(lowercaseQuery) ||
          airport.icaoCode.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Get airports by region from JSON data
  static Future<List<Airport>> getAirportsByRegion(String region) async {
    final airportsByRegion = await loadAirports();

    List<Airport> airports = [];
    if (airportsByRegion.containsKey(region)) {
      airportsByRegion[region]!.forEach((country, cities) {
        cities.forEach((city, airportList) {
          airports.addAll(airportList);
        });
      });
    }
    return airports;
  }

  /// Get airports by country from JSON data
  static Future<List<Airport>> getAirportsByCountry(String country) async {
    final airportsByRegion = await loadAirports();

    List<Airport> airports = [];
    airportsByRegion.forEach((region, countries) {
      if (countries.containsKey(country)) {
        countries[country]!.forEach((city, airportList) {
          airports.addAll(airportList);
        });
      }
    });
    return airports;
  }

  /// Get hub airports only from JSON data
  static Future<List<Airport>> getHubAirports() async {
    final allAirports = await getAllAirports();
    return allAirports.where((airport) => airport.isHub).toList();
  }

  /// Clear cache - useful for testing or when data needs to be reloaded
  static void clearCache() {
    _cachedAirports = null;
    _isLoaded = false;
  }

  /// Fallback to hardcoded airports if JSON loading fails
  static Map<String, Map<String, Map<String, List<Airport>>>>
  _getFallbackAirports() {
    return {
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
              hubLevel: 5,
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
        },
      },
    };
  }
}
