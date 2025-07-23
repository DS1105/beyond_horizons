/// Enhanced airport selection widget with advanced filtering capabilities
/// Designed for scalable airport management with hundreds of airports
import 'package:flutter/material.dart';
import 'package:beyond_horizons/models/airport.dart';
import 'package:beyond_horizons/services/airport_data_service.dart';

/// Advanced airport selection widget with comprehensive filtering
/// Supports region, country, hub level, and distance-based filtering
class AdvancedAirportSelector extends StatefulWidget {
  final Function(Airport) onAirportSelected;
  final Airport? excludeAirport; // Airport to exclude from results
  final Airport? referenceAirport; // Airport for distance calculations
  final String title;

  const AdvancedAirportSelector({
    Key? key,
    required this.onAirportSelected,
    this.excludeAirport,
    this.referenceAirport,
    this.title = "Select Airport",
  }) : super(key: key);

  @override
  _AdvancedAirportSelectorState createState() =>
      _AdvancedAirportSelectorState();
}

class _AdvancedAirportSelectorState extends State<AdvancedAirportSelector> {
  final TextEditingController searchController = TextEditingController();

  List<Airport> filteredAirports = [];
  Map<String, List<Airport>>? distanceGroupedAirports;
  String? selectedRegion;
  String? selectedCountry;
  int? minHubLevel;
  bool? showOnlyHubs;
  bool showDistanceRanges = false;
  bool isLoading = false;

  // Available filter options
  final List<String> regions = [
    'Europe',
    'North America',
    'Asia',
    'Africa',
    'South America',
    'Oceania',
  ];
  final List<String> hubLevels = ['1', '2', '3', '4', '5'];

  @override
  void initState() {
    super.initState();
    _performSearch();
    searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _performSearch() async {
    try {
      final searchResults = await AirportDataService.advancedSearch(
        query: searchController.text,
        region: selectedRegion,
        country: selectedCountry,
        minHubLevel: minHubLevel,
        isHub: showOnlyHubs,
      );

      setState(() {
        filteredAirports = searchResults;

        // Remove excluded airport
        if (widget.excludeAirport != null) {
          filteredAirports =
              filteredAirports
                  .where((airport) => airport != widget.excludeAirport)
                  .toList();
        }

        // Sort by distance if reference airport is provided
        if (widget.referenceAirport != null) {
          filteredAirports.sort((a, b) {
            double distanceA = widget.referenceAirport!.distanceTo(a);
            double distanceB = widget.referenceAirport!.distanceTo(b);
            return distanceA.compareTo(distanceB);
          });
        } else {
          // Sort alphabetically by name
          filteredAirports.sort((a, b) => a.name.compareTo(b.name));
        }
      });

      // Load distance groups if needed
      if (showDistanceRanges && widget.referenceAirport != null) {
        _loadDistanceGroups();
      }
    } catch (e) {
      print('Error loading airports: $e');
      // Show error message to user if widget is still mounted
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load airport data')));
      }
    }
  }

  /// Load airports grouped by distance ranges
  void _loadDistanceGroups() async {
    if (widget.referenceAirport == null) return;

    try {
      final grouped = await AirportDataService.getAirportsByDistanceRanges(
        widget.referenceAirport!,
      );

      setState(() {
        distanceGroupedAirports = grouped;
      });
    } catch (e) {
      print('Error loading distance groups: $e');
    }
  }

  void _clearFilters() {
    setState(() {
      searchController.clear();
      selectedRegion = null;
      selectedCountry = null;
      minHubLevel = null;
      showOnlyHubs = null;
      showDistanceRanges = false;
      distanceGroupedAirports = null;
    });
    _performSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: _clearFilters,
            tooltip: "Clear Filters",
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search airports by name, IATA, city...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                suffixIcon:
                    searchController.text.isNotEmpty
                        ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                          },
                        )
                        : null,
              ),
            ),
          ),

          // Filter chips
          Container(
            height: 60,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Region filter
                  _buildFilterChip(
                    "Region: ${selectedRegion ?? 'All'}",
                    selectedRegion != null,
                    () => _showRegionPicker(),
                  ),
                  SizedBox(width: 8),

                  // Hub level filter
                  _buildFilterChip(
                    "Hub Level: ${minHubLevel?.toString() ?? 'All'}",
                    minHubLevel != null,
                    () => _showHubLevelPicker(),
                  ),
                  SizedBox(width: 8),

                  // Hubs only filter
                  _buildFilterChip(
                    "Hubs Only",
                    showOnlyHubs == true,
                    () => setState(() {
                      showOnlyHubs = showOnlyHubs == true ? null : true;
                      _performSearch();
                    }),
                  ),

                  if (widget.referenceAirport != null) ...[
                    SizedBox(width: 8),
                    _buildFilterChip(
                      "Distance Groups",
                      showDistanceRanges,
                      () => setState(() {
                        showDistanceRanges = !showDistanceRanges;
                        if (showDistanceRanges) {
                          _loadDistanceGroups();
                        }
                      }),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text("${filteredAirports.length} airports found"),
                Spacer(),
                if (widget.referenceAirport != null)
                  Text(
                    "Sorted by distance",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
              ],
            ),
          ),

          // Airport list
          Expanded(
            child:
                showDistanceRanges && widget.referenceAirport != null
                    ? _buildDistanceGroupedList()
                    : _buildRegularList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: Colors.blue[100],
      checkmarkColor: Colors.blue[800],
    );
  }

  Widget _buildRegularList() {
    return ListView.builder(
      itemCount: filteredAirports.length,
      itemBuilder: (context, index) {
        final airport = filteredAirports[index];
        return _buildAirportTile(airport);
      },
    );
  }

  Widget _buildDistanceGroupedList() {
    if (distanceGroupedAirports == null) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView(
      children:
          distanceGroupedAirports!.entries.map((entry) {
            if (entry.value.isEmpty) return SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "${entry.key} (${entry.value.length})",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
                ...entry.value.map((airport) => _buildAirportTile(airport)),
                Divider(thickness: 2),
              ],
            );
          }).toList(),
    );
  }

  Widget _buildAirportTile(Airport airport) {
    String? distanceText;
    if (widget.referenceAirport != null) {
      double distance = widget.referenceAirport!.distanceTo(airport);
      distanceText = "${distance.round()} km";
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: airport.isHub ? Colors.blue : Colors.grey[300],
        child: Text(
          airport.iataCode,
          style: TextStyle(
            color: airport.isHub ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      title: Text("${airport.name}"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${airport.city}, ${airport.country}"),
          Row(
            children: [
              Icon(Icons.star, size: 16, color: Colors.amber),
              if (distanceText != null) ...[
                Text(" • "),
                Icon(Icons.flight, size: 16, color: Colors.grey),
                Text(" $distanceText"),
              ],
            ],
          ),
        ],
      ),
      trailing:
          airport.isCongested
              ? Icon(Icons.warning, color: Colors.orange)
              : Icon(Icons.check_circle, color: Colors.green),
      onTap: () {
        widget.onAirportSelected(airport);
        Navigator.pop(context);
      },
    );
  }

  void _showRegionPicker() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Select Region"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text("All Regions"),
                  onTap: () {
                    setState(() => selectedRegion = null);
                    Navigator.pop(context);
                    _performSearch();
                  },
                ),
                ...regions.map(
                  (region) => ListTile(
                    title: Text(region),
                    onTap: () {
                      setState(() => selectedRegion = region);
                      Navigator.pop(context);
                      _performSearch();
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showHubLevelPicker() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Minimum Hub Level"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text("All Levels"),
                  onTap: () {
                    setState(() => minHubLevel = null);
                    Navigator.pop(context);
                    _performSearch();
                  },
                ),
                ...hubLevels.map(
                  (level) => ListTile(
                    title: Text("Level $level and above"),
                    onTap: () {
                      setState(() => minHubLevel = int.parse(level));
                      Navigator.pop(context);
                      _performSearch();
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
