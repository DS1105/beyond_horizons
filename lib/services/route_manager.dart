import 'package:beyond_horizons/models/route.dart';

/// Singleton manager for handling flight routes
/// Stores all created routes and manages route operations
class RouteManager {
  static final RouteManager _instance = RouteManager._internal();
  factory RouteManager() => _instance;
  RouteManager._internal();

  // List of all persistent routes
  final List<Route> _routes = [];

  /// Getter for all routes (read-only)
  List<Route> get routes => List.unmodifiable(_routes);

  /// Returns all routes (same as routes getter for compatibility)
  List<Route> getAllRoutes() => List.unmodifiable(_routes);

  /// Number of created routes
  int get routeCount => _routes.length;

  /// Creates a persistent route from a temporary route
  /// Assigns the aircraft to the route and stores it
  void addRoute(Route tempRoute) {
    // Validate that route is complete
    if (!tempRoute.isComplete) {
      throw Exception("Route is not complete - cannot save");
    }

    // Create persistent route with ID
    final persistentRoute = Route.fromTemporary(tempRoute);

    // Mark all aircraft as assigned to route
    for (var aircraft in persistentRoute.aircraft) {
      aircraft.isAssignedToRoute = true;
    }

    // Also mark selectedAircraft if it's not in the aircraft list
    if (persistentRoute.selectedAircraft != null &&
        !persistentRoute.aircraft.contains(persistentRoute.selectedAircraft)) {
      persistentRoute.selectedAircraft!.isAssignedToRoute = true;
    }

    // Add to routes list
    _routes.add(persistentRoute);
  }

  /// Deletes a route by ID
  /// Also frees up the assigned aircraft
  bool removeRoute(int routeId) {
    final index = _routes.indexWhere((route) => route.id == routeId);
    if (index != -1) {
      // Free up all aircraft
      for (var aircraft in _routes[index].aircraft) {
        aircraft.isAssignedToRoute = false;
      }

      // Also free selectedAircraft if it's not in the aircraft list
      if (_routes[index].selectedAircraft != null &&
          !_routes[index].aircraft.contains(_routes[index].selectedAircraft)) {
        _routes[index].selectedAircraft!.isAssignedToRoute = false;
      }
      // Remove route
      _routes.removeAt(index);
      return true;
    }
    return false;
  }

  /// Finds a route by ID
  Route? getRouteById(int routeId) {
    try {
      return _routes.firstWhere((route) => route.id == routeId);
    } catch (e) {
      return null;
    }
  }

  /// Resets all routes (for game restart)
  void resetRoutes() {
    // Free up all aircraft
    for (var route in _routes) {
      for (var aircraft in route.aircraft) {
        aircraft.isAssignedToRoute = false;
      }

      // Also free selectedAircraft if it's not in the aircraft list
      if (route.selectedAircraft != null &&
          !route.aircraft.contains(route.selectedAircraft)) {
        route.selectedAircraft!.isAssignedToRoute = false;
      }
    }
    // Clear routes
    _routes.clear();
  }
}
