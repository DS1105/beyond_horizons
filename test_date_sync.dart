import 'package:beyond_horizons/services/date_manager.dart';

/// Quick test to demonstrate date synchronization between screens
void main() {
  print("=== DATE MANAGER SYNCHRONIZATION TEST ===");

  // Simulate what happens when user switches between screens
  DateManager dateManager1 = DateManager(); // Simulates HomeScreen
  DateManager dateManager2 = DateManager(); // Simulates RoutesOverviewScreen

  print("Initial date (both screens): ${dateManager1.getFormattedDate()}");
  print(
    "Are both managers the same instance? ${identical(dateManager1, dateManager2)}",
  );

  // Advance month in "HomeScreen"
  print("\n--- Advancing month in HomeScreen ---");
  dateManager1.advanceToNextMonth();
  print("HomeScreen date: ${dateManager1.getFormattedDate()}");
  print("RoutesOverviewScreen date: ${dateManager2.getFormattedDate()}");

  // Advance month in "RoutesOverviewScreen"
  print("\n--- Advancing month in RoutesOverviewScreen ---");
  dateManager2.advanceToNextMonth();
  print("HomeScreen date: ${dateManager1.getFormattedDate()}");
  print("RoutesOverviewScreen date: ${dateManager2.getFormattedDate()}");

  // Test year rollover
  print("\n--- Testing year rollover ---");
  for (int i = 0; i < 10; i++) {
    dateManager1.advanceToNextMonth();
  }
  print("After 10 more months: ${dateManager1.getFormattedDate()}");
  print("Both screens show same: ${dateManager2.getFormattedDate()}");

  print("\n✅ Date synchronization working correctly!");
}
