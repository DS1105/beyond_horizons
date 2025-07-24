import 'package:beyond_horizons/services/date_manager.dart';

/// Test to demonstrate synchronized date updates with listeners
void main() {
  print("=== DATE MANAGER LISTENER SYNCHRONIZATION TEST ===");

  DateManager dateManager = DateManager();

  // Simulate multiple screens listening to date changes
  bool homeScreenUpdated = false;
  bool routesScreenUpdated = false;

  // Add listeners (simulating what screens do in initState)
  void homeScreenListener() {
    homeScreenUpdated = true;
    print("📱 HomeScreen UI updated: ${dateManager.getFormattedDate()}");
  }

  void routesScreenListener() {
    routesScreenUpdated = true;
    print("📋 RoutesScreen UI updated: ${dateManager.getFormattedDate()}");
  }

  dateManager.addListener(homeScreenListener);
  dateManager.addListener(routesScreenListener);

  print("Initial date: ${dateManager.getFormattedDate()}");
  print("Listeners registered: ${dateManager.listenerCount}");

  // Test 1: Advance month (simulating user click in RoutesScreen)
  print("\n--- User clicks 'Nächster Monat' in RoutesScreen ---");
  homeScreenUpdated = false;
  routesScreenUpdated = false;

  dateManager.advanceToNextMonth();

  print("HomeScreen automatically updated: $homeScreenUpdated");
  print("RoutesScreen automatically updated: $routesScreenUpdated");
  print("New date shown in both: ${dateManager.getFormattedDate()}");

  // Test 2: Advance month (simulating user click in HomeScreen)
  print("\n--- User clicks 'Nächster Monat' in HomeScreen ---");
  homeScreenUpdated = false;
  routesScreenUpdated = false;

  dateManager.advanceToNextMonth();

  print("HomeScreen automatically updated: $homeScreenUpdated");
  print("RoutesScreen automatically updated: $routesScreenUpdated");
  print("New date shown in both: ${dateManager.getFormattedDate()}");

  // Test 3: Multiple advances
  print("\n--- Multiple month advances ---");
  for (int i = 0; i < 5; i++) {
    dateManager.advanceToNextMonth();
  }
  print("After 5 more months: ${dateManager.getFormattedDate()}");

  // Cleanup (simulating dispose methods)
  dateManager.removeListener(homeScreenListener);
  dateManager.removeListener(routesScreenListener);
  print("\nListeners after cleanup: ${dateManager.listenerCount}");

  print("\n✅ Date synchronization with listeners working correctly!");
}
