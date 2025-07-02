/// Extended airport data loader for importing from external sources
/// This class will be used for loading airport data from JSON files or databases
import 'package:beyond_horizons/models/airport.dart';
import 'package:beyond_horizons/data/airports_data.dart';
import 'package:beyond_horizons/services/json_airport_loader.dart';

/// Service class for managing large-scale airport data
/// Provides methods for loading, filtering, and organizing airport data
class AirportDataService {
  static Map<String, Map<String, Map<String, List<Airport>>>>? _airportData;
  static bool _useJsonData = true; // Toggle between JSON and hardcoded data

  /// Initialize airport data from JSON (preferred) or fallback to hardcoded
  static Future<void> _initializeData() async {
    if (_airportData != null) return;

    try {
      if (_useJsonData) {
        _airportData = await JsonAirportLoader.loadAirports();
        print('Airport data loaded from JSON successfully');
      } else {
        throw Exception('Using hardcoded fallback');
      }
    } catch (e) {
      print('Failed to load JSON data, using hardcoded fallback: $e');
      _airportData = AirportsData.getAirportsByRegionMap();
      _useJsonData = false;
    }
  }

  /// Get all airports with async initialization
  static Future<List<Airport>> getAllAirports() async {
    await _initializeData();
    final List<Airport> airports = [];

    _airportData!.forEach((regionName, countries) {
      countries.forEach((countryName, cities) {
        cities.forEach((cityName, cityAirports) {
          airports.addAll(cityAirports);
        });
      });
    });

    return airports;
  }

  /// Load airports by region with performance optimization
  /// Useful when you have hundreds of airports
  static Future<List<Airport>> loadAirportsByRegion(String region) async {
    await _initializeData();
    final List<Airport> airports = [];

    if (_airportData!.containsKey(region)) {
      _airportData![region]!.forEach((countryName, cities) {
        cities.forEach((cityName, cityAirports) {
          airports.addAll(cityAirports);
        });
      });
    }

    return airports;
  }

  /// Load airports by country with caching
  static Map<String, List<Airport>> _countryCache = {};

  static Future<List<Airport>> loadAirportsByCountry(String country) async {
    if (_countryCache.containsKey(country)) {
      return _countryCache[country]!;
    }

    await _initializeData();
    final List<Airport> airports = [];

    _airportData!.forEach((regionName, countries) {
      if (countries.containsKey(country)) {
        countries[country]!.forEach((cityName, cityAirports) {
          airports.addAll(cityAirports);
        });
      }
    });

    _countryCache[country] = airports;
    return airports;
  }

  /// Advanced search with multiple criteria
  static Future<List<Airport>> advancedSearch({
    String? query,
    String? region,
    String? country,
    String? city,
    int? minHubLevel,
    bool? isHub,
    bool? showCongested,
  }) async {
    List<Airport> results = await getAllAirports();

    // Filter by query (name, IATA, ICAO, city, country)
    if (query != null && query.isNotEmpty) {
      final queryLower = query.toLowerCase();
      results =
          results
              .where(
                (airport) =>
                    airport.name.toLowerCase().contains(queryLower) ||
                    airport.iataCode.toLowerCase().contains(queryLower) ||
                    airport.icaoCode.toLowerCase().contains(queryLower) ||
                    airport.city.toLowerCase().contains(queryLower) ||
                    airport.country.toLowerCase().contains(queryLower),
              )
              .toList();
    }

    // Filter by region
    if (region != null) {
      results = results.where((airport) => airport.region == region).toList();
    }

    // Filter by country
    if (country != null) {
      results = results.where((airport) => airport.country == country).toList();
    }

    // Filter by city
    if (city != null) {
      results = results.where((airport) => airport.city == city).toList();
    }

    // Filter by hub level
    if (minHubLevel != null) {
      results =
          results.where((airport) => airport.hubLevel >= minHubLevel).toList();
    }

    // Filter by hub status
    if (isHub != null) {
      results = results.where((airport) => airport.isHub == isHub).toList();
    }

    // Filter by congestion status
    if (showCongested != null) {
      if (showCongested) {
        results = results.where((airport) => airport.isCongested).toList();
      } else {
        results = results.where((airport) => !airport.isCongested).toList();
      }
    }

    return results;
  }

  /// Get recommended airports for route creation
  /// Based on distance, hub status, and capacity
  static Future<List<Airport>> getRecommendedDestinations(
    Airport startAirport, {
    double? maxDistance,
    int? minHubLevel,
    int? maxResults,
  }) async {
    List<Airport> allAirports = await getAllAirports();

    // Remove the start airport from results
    allAirports =
        allAirports.where((airport) => airport != startAirport).toList();

    // Filter by distance if specified
    if (maxDistance != null) {
      allAirports =
          allAirports.where((airport) {
            return startAirport.distanceTo(airport) <= maxDistance;
          }).toList();
    }

    // Filter by hub level if specified
    if (minHubLevel != null) {
      allAirports =
          allAirports
              .where((airport) => airport.hubLevel >= minHubLevel)
              .toList();
    }

    // Sort by distance (closest first)
    allAirports.sort((a, b) {
      double distanceA = startAirport.distanceTo(a);
      double distanceB = startAirport.distanceTo(b);
      return distanceA.compareTo(distanceB);
    });

    // Limit results if specified
    if (maxResults != null && allAirports.length > maxResults) {
      allAirports = allAirports.sublist(0, maxResults);
    }

    return allAirports;
  }

  /// Get airports grouped by distance ranges
  static Future<Map<String, List<Airport>>> getAirportsByDistanceRanges(
    Airport referenceAirport,
  ) async {
    List<Airport> allAirports = await getAllAirports();
    allAirports =
        allAirports.where((airport) => airport != referenceAirport).toList();

    Map<String, List<Airport>> grouped = {
      'Short Haul (< 1500 km)': [],
      'Medium Haul (1500-4000 km)': [],
      'Long Haul (> 4000 km)': [],
    };

    for (Airport airport in allAirports) {
      double distance = referenceAirport.distanceTo(airport);

      if (distance < 1500) {
        grouped['Short Haul (< 1500 km)']!.add(airport);
      } else if (distance < 4000) {
        grouped['Medium Haul (1500-4000 km)']!.add(airport);
      } else {
        grouped['Long Haul (> 4000 km)']!.add(airport);
      }
    }

    return grouped;
  }

  /// Get statistics about airport data
  static Future<Map<String, dynamic>> getAirportStatistics() async {
    List<Airport> allAirports = await getAllAirports();

    Map<String, int> regionCounts = {};
    Map<String, int> countryCounts = {};
    Map<String, int> hubLevelCounts = {};

    int totalHubs = 0;
    int congestedAirports = 0;

    for (Airport airport in allAirports) {
      // Count by region
      regionCounts[airport.region] = (regionCounts[airport.region] ?? 0) + 1;

      // Count by country
      countryCounts[airport.country] =
          (countryCounts[airport.country] ?? 0) + 1;

      // Count by hub level
      String hubLevelKey = 'Level ${airport.hubLevel}';
      hubLevelCounts[hubLevelKey] = (hubLevelCounts[hubLevelKey] ?? 0) + 1;

      // Count hubs
      if (airport.isHub) totalHubs++;

      // Count congested airports
      if (airport.isCongested) congestedAirports++;
    }

    return {
      'totalAirports': allAirports.length,
      'totalHubs': totalHubs,
      'congestedAirports': congestedAirports,
      'regionCounts': regionCounts,
      'countryCounts': countryCounts,
      'hubLevelCounts': hubLevelCounts,
      'averageSlotCapacity':
          allAirports.map((a) => a.slotCapacity).reduce((a, b) => a + b) /
          allAirports.length,
      'averageTerminalCapacity':
          allAirports.map((a) => a.terminalCapacity).reduce((a, b) => a + b) /
          allAirports.length,
    };
  }
}
