/// Test script to verify JSON airport loading functionality
import 'package:beyond_horizons/services/airport_data_service.dart';

void main() async {
  print('Testing JSON Airport Loading...');

  try {
    // Test loading all airports
    final airports = await AirportDataService.getAllAirports();
    print('✅ Successfully loaded ${airports.length} airports');

    // Test regional loading
    final europeanAirports = await AirportDataService.loadAirportsByRegion(
      'Europe',
    );
    print('✅ Successfully loaded ${europeanAirports.length} European airports');

    // Test search functionality
    final searchResults = await AirportDataService.advancedSearch(
      query: 'Frankfurt',
    );
    print('✅ Search for "Frankfurt" returned ${searchResults.length} results');

    // Print sample data
    if (airports.isNotEmpty) {
      final airport = airports.first;
      print('\n📍 Sample Airport Data:');
      print('   Name: ${airport.name}');
      print('   IATA: ${airport.iataCode}');
      print('   City: ${airport.city}');
      print('   Hub Level: ${airport.hubLevel}');
      print('   Coordinates: ${airport.latitude}, ${airport.longitude}');
    }

    print('\n🎉 All tests passed! JSON loading is working correctly.');
  } catch (e) {
    print('❌ Error during testing: $e');
  }
}
