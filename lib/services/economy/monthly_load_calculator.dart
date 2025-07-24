/// Calculator for monthly passenger load factor simulation
///
/// Purpose: Simple calculation of load factors per route
/// - Load factor percentages per route (actual vs. capacity)
///
/// TODO: Later add complex features like:
/// - Seasonal demand variations, competition effects, etc.

import 'dart:math';
import 'package:beyond_horizons/models/route.dart';
import 'package:beyond_horizons/services/route_manager.dart';

/// Simple result object for load factor per route
class LoadFactorResult {
  final int routeId;
  final double economyLoadFactor; // 0.0 to 1.0 (0% to 100%)
  final double businessLoadFactor; // 0.0 to 1.0 (0% to 100%)
  final double firstLoadFactor; // 0.0 to 1.0 (0% to 100%)

  LoadFactorResult({
    required this.routeId,
    required this.economyLoadFactor,
    required this.businessLoadFactor,
    required this.firstLoadFactor,
  });

  @override
  String toString() {
    return 'Route $routeId: Economy ${(economyLoadFactor * 100).toStringAsFixed(1)}%, Business ${(businessLoadFactor * 100).toStringAsFixed(1)}%, First ${(firstLoadFactor * 100).toStringAsFixed(1)}%';
  }
}

class MonthlyLoadCalculator {
  final Random _random = Random();

  /// Main method: Calculate load factor for all active routes
  /// Returns simple list of LoadFactorResult objects
  List<LoadFactorResult> calculateMonthlyLoads() {
    List<LoadFactorResult> results = [];
    List<Route> allRoutes = RouteManager().getAllRoutes();

    if (allRoutes.isEmpty) {
      return results;
    }

    for (Route route in allRoutes) {
      LoadFactorResult result = _calculateRouteLoadFactor(route);
      results.add(result);
    }

    return results;
  }

  /// Calculate load factor for a single route
  /// Simple random implementation for all three classes
  LoadFactorResult _calculateRouteLoadFactor(Route route) {
    // Simple load factors per class: different ranges
    // Economy: Usually highest load (50% - 95%)
    double economyLoadFactor = 0.5 + (_random.nextDouble() * 0.45);

    // Business: Medium load (30% - 80%)
    double businessLoadFactor = 0.3 + (_random.nextDouble() * 0.5);

    // First: Usually lowest load (20% - 70%)
    double firstLoadFactor = 0.2 + (_random.nextDouble() * 0.5);

    // Clamp all between 10%-95%
    economyLoadFactor = max(0.1, min(0.95, economyLoadFactor));
    businessLoadFactor = max(0.1, min(0.95, businessLoadFactor));
    firstLoadFactor = max(0.1, min(0.95, firstLoadFactor));

    return LoadFactorResult(
      routeId: route.id ?? 0,
      economyLoadFactor: economyLoadFactor,
      businessLoadFactor: businessLoadFactor,
      firstLoadFactor: firstLoadFactor,
    );
  }
}
