/// Route creation screen for setting up new flight routes
/// Allows players to create routes between airports with assigned aircraft
import 'package:beyond_horizons/models/aircraft.dart';
import 'package:beyond_horizons/models/route.dart' as flight_route;
import 'package:beyond_horizons/models/airport.dart';
import 'package:beyond_horizons/models/airline.dart';
import 'package:beyond_horizons/services/airport_data_service.dart';
import 'package:flutter/material.dart';

/// Screen for creating new flight routes between airports
/// Manages airport selection, aircraft assignment, flight frequency, and service options
class RouteCreationScreen extends StatefulWidget {
  final Airline airline; // Airline operating the route
  final List<Aircraft> purchasedAircraft; // Available aircraft for assignment
  final Airport? initialStartAirport; // Optional initial start airport
  final Airport?
  initialDestinationAirport; // Optional initial destination airport

  /// Constructor requiring airline and available aircraft
  /// Airport parameters are optional for flexible route creation
  RouteCreationScreen({
    required this.airline,
    required this.purchasedAircraft, // Player's aircraft fleet
    this.initialStartAirport, // Optional pre-selected start airport
    this.initialDestinationAirport, // Optional pre-selected destination airport
  });

  @override
  _RouteCreationScreenState createState() => _RouteCreationScreenState();
}

/// State class for the route creation screen
/// Manages route configuration, airport selection, and aircraft assignments
class _RouteCreationScreenState extends State<RouteCreationScreen> {
  /// Available airports in the simulation - loaded from central data
  List<Airport> availableAirports = [];

  /// Currently selected airports for the route
  Airport? selectedStartAirport;
  Airport? selectedDestinationAirport;

  /// Text controllers for airport search fields
  final TextEditingController startAirportController = TextEditingController();
  final TextEditingController destinationAirportController =
      TextEditingController();

  /// Filtered airport lists for search functionality
  List<Airport> filteredStartAirports = [];
  List<Airport> filteredDestinationAirports = [];

  /// Show/hide dropdown flags
  bool showStartDropdown = false;
  bool showDestinationDropdown = false;

  /// List of aircraft assigned to this specific route
  final List<Aircraft> assignedAircraft = [];

  /// Ticket pricing structure for different passenger classes
  final Map<String, double> _ticketPrices = {
    'Economy': 100.0, // Economy class base price
    'Business': 250.0, // Business class base price
  };

  bool _onboardService = false; // Whether to provide onboard services
  int _flightsPerWeek = 0; // Number of flights per week on this route
  @override
  void initState() {
    super.initState();

    // Load airports from central data source
    _loadAirports();

    // Initialize with optional pre-selected airports (but keep text fields empty)
    selectedStartAirport = widget.initialStartAirport;
    selectedDestinationAirport = widget.initialDestinationAirport;

    // Keep text fields empty for better UX - user should search
    // Note: We store the selected airports but don't fill the text fields

    // Initialize filtered lists will be updated after loading
  }

  @override
  void dispose() {
    // Clean up controllers
    startAirportController.dispose();
    destinationAirportController.dispose();
    super.dispose();
  }

  /// Load airports using the new async data service
  Future<void> _loadAirports() async {
    try {
      final airports = await AirportDataService.getAllAirports();
      setState(() {
        availableAirports = airports;
        _updateFilteredLists();
      });
      print('✅ Loaded ${airports.length} airports successfully');
    } catch (e) {
      print('❌ Error loading airports: $e');
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load airport data')));
      }
    }
  }

  /// Update filtered airport lists based on current selections
  void _updateFilteredLists() {
    filteredStartAirports =
        availableAirports
            .where((airport) => airport != selectedDestinationAirport)
            .toList();
    filteredDestinationAirports =
        availableAirports
            .where((airport) => airport != selectedStartAirport)
            .toList();
  }

  /// Filters start airports based on search text
  /// Excludes the currently selected destination airport to prevent conflicts
  /// Searches by name, city, country, and IATA code
  /// Filter start airports based on search query
  /// Excludes the currently selected destination airport
  void filterStartAirports(String query) {
    print(
      '🔍 Filtering start airports with query: "$query", available: ${availableAirports.length}',
    );
    setState(() {
      // Don't filter if airports haven't loaded yet
      if (availableAirports.isEmpty) {
        filteredStartAirports = [];
        showStartDropdown = false;
        print('❌ No airports loaded yet');
        return;
      }

      if (query.isEmpty) {
        // Show all airports when field is empty but focused
        filteredStartAirports =
            availableAirports
                .where((airport) => airport != selectedDestinationAirport)
                .toList();
        showStartDropdown = true;
        print('📋 Showing all ${filteredStartAirports.length} airports');
      } else {
        filteredStartAirports =
            availableAirports
                .where(
                  (airport) =>
                      airport != selectedDestinationAirport &&
                      (airport.name.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ||
                          airport.city.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ||
                          airport.country.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ||
                          airport.iataCode.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ||
                          airport.icaoCode.toLowerCase().contains(
                            query.toLowerCase(),
                          )),
                )
                .toList();
        showStartDropdown = filteredStartAirports.isNotEmpty;
        print('🎯 Found ${filteredStartAirports.length} matching airports');
      }
    });
  }

  /// Filters destination airports based on search text
  /// Excludes the currently selected start airport to prevent conflicts
  /// Searches by name, city, country, and IATA code
  /// Filters destination airports based on search text
  /// Excludes the currently selected start airport to prevent conflicts
  /// Searches by name, city, country, and IATA code
  void filterDestinationAirports(String query) {
    setState(() {
      // Don't filter if airports haven't loaded yet
      if (availableAirports.isEmpty) {
        filteredDestinationAirports = [];
        showDestinationDropdown = false;
        return;
      }

      if (query.isEmpty) {
        // Show all airports when field is empty but focused
        filteredDestinationAirports =
            availableAirports
                .where((airport) => airport != selectedStartAirport)
                .toList();
        showDestinationDropdown = true;
      } else {
        filteredDestinationAirports =
            availableAirports
                .where(
                  (airport) =>
                      airport != selectedStartAirport &&
                      (airport.name.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ||
                          airport.city.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ||
                          airport.country.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ||
                          airport.iataCode.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ||
                          airport.icaoCode.toLowerCase().contains(
                            query.toLowerCase(),
                          )),
                )
                .toList();
        showDestinationDropdown = filteredDestinationAirports.isNotEmpty;
      }
    });
  }

  /// Selects start airport and updates UI
  /// Also refreshes destination airport list to exclude the selected start airport
  void selectStartAirport(Airport airport) {
    setState(() {
      selectedStartAirport = airport;
      startAirportController.text = "${airport.name} (${airport.iataCode})";
      showStartDropdown = false;

      // Clear destination if same as start
      if (selectedDestinationAirport == airport) {
        selectedDestinationAirport = null;
        destinationAirportController.text = '';
      }
    });
  }

  /// Selects destination airport and updates UI
  /// Also refreshes start airport list to exclude the selected destination airport
  void selectDestinationAirport(Airport airport) {
    setState(() {
      selectedDestinationAirport = airport;
      destinationAirportController.text =
          "${airport.name} (${airport.iataCode})";
      showDestinationDropdown = false;

      // Clear start if same as destination
      if (selectedStartAirport == airport) {
        selectedStartAirport = null;
        startAirportController.text = '';
      }
    });
  }

  /// Updates and displays current route capacity
  /// Calculates total passenger capacity based on assigned aircraft and flight frequency
  void updateCapacity() {
    // Only calculate if both airports are selected
    if (selectedStartAirport != null && selectedDestinationAirport != null) {
      // Create a temporary route object to calculate capacity
      double newCapacity =
          flight_route.FlightRoute(
            startAirport: selectedStartAirport!,
            destinationAirport: selectedDestinationAirport!,
            aircraft: assignedAircraft,
            flightsPerWeek: _flightsPerWeek,
            ticketPrices: _ticketPrices,
            onboardService: _onboardService,
          ).calculateCapacity();

      print("Current Route Capacity: $newCapacity passengers per week");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Route")), // Screen title
      body: GestureDetector(
        onTap: () {
          // Hide dropdowns when tapping outside
          setState(() {
            showStartDropdown = false;
            showDestinationDropdown = false;
          });
          // Unfocus text fields
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Airport selection section
              Text(
                "Select Route Airports:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              // Start airport selection
              Text("Start Airport:"),
              SizedBox(height: 8),
              TextField(
                controller: startAirportController,
                decoration: InputDecoration(
                  hintText: "Search for start airport...",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon:
                      startAirportController.text.isNotEmpty
                          ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                startAirportController.clear();
                                selectedStartAirport = null;
                                showStartDropdown = false;
                                filteredStartAirports = [];
                              });
                            },
                          )
                          : Icon(Icons.search),
                ),
                onChanged: (query) {
                  filterStartAirports(query);
                  setState(() {
                    showStartDropdown = true;
                  });
                },
                onTap: () {
                  filterStartAirports(startAirportController.text);
                  setState(() {
                    showStartDropdown = true;
                  });
                },
              ),
              if (showStartDropdown && filteredStartAirports.isNotEmpty)
                Container(
                  height: 200,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: ListView.builder(
                    itemCount: filteredStartAirports.length,
                    itemBuilder: (context, index) {
                      final airport = filteredStartAirports[index];
                      String distanceText = "";
                      if (selectedDestinationAirport != null) {
                        double distance = airport.distanceTo(
                          selectedDestinationAirport!,
                        );
                        distanceText = " • ${distance.round()} km";
                      }
                      return ListTile(
                        tileColor: Colors.white,
                        title: Text(
                          "${airport.name} (${airport.iataCode})",
                          style: TextStyle(backgroundColor: Colors.white),
                        ),
                        subtitle: Text(
                          "${airport.city}, ${airport.country}$distanceText",
                          style: TextStyle(backgroundColor: Colors.white),
                        ),
                        trailing:
                            airport.isHub
                                ? Icon(Icons.hub, color: Colors.blue, size: 20)
                                : null,
                        onTap: () {
                          selectStartAirport(airport);
                          setState(() {
                            showStartDropdown = false;
                          });
                        },
                      );
                    },
                  ),
                ),

              SizedBox(height: 16),

              // Destination airport selection
              Text("Destination Airport:"),
              SizedBox(height: 8),
              TextField(
                controller: destinationAirportController,
                decoration: InputDecoration(
                  hintText: "Search for destination airport...",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon:
                      destinationAirportController.text.isNotEmpty
                          ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                destinationAirportController.clear();
                                selectedDestinationAirport = null;
                                showDestinationDropdown = false;
                                filteredDestinationAirports = [];
                              });
                            },
                          )
                          : Icon(Icons.search),
                ),
                onChanged: (query) {
                  filterDestinationAirports(query);
                  setState(() {
                    showDestinationDropdown = true;
                  });
                },
                onTap: () {
                  filterDestinationAirports(destinationAirportController.text);
                  setState(() {
                    showDestinationDropdown = true;
                  });
                },
              ),
              if (showDestinationDropdown &&
                  filteredDestinationAirports.isNotEmpty)
                Container(
                  height: 200,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: ListView.builder(
                    itemCount: filteredDestinationAirports.length,
                    itemBuilder: (context, index) {
                      final airport = filteredDestinationAirports[index];
                      String distanceText = "";
                      if (selectedStartAirport != null) {
                        double distance = selectedStartAirport!.distanceTo(
                          airport,
                        );
                        distanceText = " • ${distance.round()} km";
                      }
                      return ListTile(
                        tileColor: Colors.white,
                        title: Text(
                          "${airport.name} (${airport.iataCode})",
                          style: TextStyle(backgroundColor: Colors.white),
                        ),
                        subtitle: Text(
                          "${airport.city}, ${airport.country}$distanceText",
                          style: TextStyle(backgroundColor: Colors.white),
                        ),
                        trailing:
                            airport.isHub
                                ? Icon(Icons.hub, color: Colors.blue, size: 20)
                                : null,
                        onTap: () {
                          selectDestinationAirport(airport);
                          setState(() {
                            showDestinationDropdown = false;
                          });
                        },
                      );
                    },
                  ),
                ),

              SizedBox(height: 20),

              // Display selected route information
              if (selectedStartAirport != null &&
                  selectedDestinationAirport != null)
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Route: ${selectedStartAirport!.shortName} → ${selectedDestinationAirport!.shortName}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Distance: ${selectedStartAirport!.distanceTo(selectedDestinationAirport!).round()} km",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 20),
              // Flight frequency control
              Text("Flights per week:"),
              Slider(
                value: _flightsPerWeek.toDouble(),
                min: 0, // Minimum flights per week
                max: 21, // Maximum 3 flights per day
                divisions: 21, // 21 possible values (0-21)
                label: _flightsPerWeek.toString(),
                onChanged: (value) {
                  setState(() {
                    _flightsPerWeek = value.round(); // Update flight frequency
                  });
                  updateCapacity(); // Recalculate capacity with new frequency
                },
              ),
              SizedBox(height: 20),
              // Service level selection
              CheckboxListTile(
                title: Text("Onboard Service"),
                value: _onboardService,
                onChanged: (value) {
                  setState(() {
                    _onboardService = value ?? false; // Toggle service option
                  });
                },
              ),
              SizedBox(height: 20),
              Text("Available Aircraft:"), // Header for aircraft list
              // Scrollable list of available aircraft
              Expanded(
                child: ListView.builder(
                  itemCount:
                      widget
                          .purchasedAircraft
                          .length, // Number of owned aircraft
                  itemBuilder: (context, index) {
                    final aircraft = widget.purchasedAircraft[index];
                    return ListTile(
                      title: Text(
                        "${aircraft.name} - ID: ${aircraft.id}",
                      ), // Aircraft name and ID
                      subtitle: Text(
                        "Model: ${aircraft.model}",
                      ), // Aircraft model
                      trailing: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Add aircraft to route if not already assigned
                            if (!assignedAircraft.contains(aircraft)) {
                              assignedAircraft.add(aircraft);
                            }
                          });
                          updateCapacity(); // Recalculate capacity with new aircraft
                        },
                        child: Text("Assign"), // Assignment button
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              // Route creation confirmation button
              ElevatedButton(
                onPressed: () {
                  // Validate that route has both airports, aircraft and flights before creating
                  if (selectedStartAirport != null &&
                      selectedDestinationAirport != null &&
                      assignedAircraft.isNotEmpty &&
                      _flightsPerWeek > 0) {
                    // Create the route object with all configured parameters
                    final route = flight_route.FlightRoute(
                      startAirport: selectedStartAirport!,
                      destinationAirport: selectedDestinationAirport!,
                      aircraft: assignedAircraft, // All assigned aircraft
                      flightsPerWeek: _flightsPerWeek, // Configured frequency
                      ticketPrices: _ticketPrices, // Pricing structure
                      onboardService: _onboardService, // Service level
                    );
                    Navigator.pop(
                      context,
                      route,
                    ); // Return route to calling screen
                  } else {
                    // Show error message if configuration is incomplete
                    String errorMessage = "Please complete the following:\n";
                    if (selectedStartAirport == null)
                      errorMessage += "- Select start airport\n";
                    if (selectedDestinationAirport == null)
                      errorMessage += "- Select destination airport\n";
                    if (assignedAircraft.isEmpty)
                      errorMessage += "- Assign at least one aircraft\n";
                    if (_flightsPerWeek == 0)
                      errorMessage += "- Set flights per week";

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage.trim()),
                        duration: Duration(seconds: 4),
                      ),
                    );
                  }
                },
                child: Text("Create Route"), // Button text
              ),
            ],
          ),
        ), // GestureDetector
      ),
    );
  }
}
