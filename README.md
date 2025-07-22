# Beyond Horizons - Airline Management Simulation

Beyond Horizons is a comprehensive airline management simulation game built with Flutter. Players can manage their own airline company, purchase aircraft, create routes between airports, and optimize their operations for profitability.

## 🎯 Project Overview

This simulation game allows players to experience the complexities of running an airline business, from fleet management to route planning and capacity optimization.

## 🏗️ Software Architecture

### Model-View Architecture
The application follows a clean Model-View architecture pattern with clear separation of concerns:

```
lib/
├── models/           # Data models and business logic
├── screens/          # UI screens and user interactions
├── widgets/          # Reusable UI components
└── main.dart         # Application entry point
```

### Core Components

#### 1. Models (`lib/models/`)
- **Airport** (`airport.dart`): Manages airport data including capacity, location, and expansion capabilities
- **Aircraft** (`aircraft.dart`): Enhanced aircraft model with realistic performance data:
  - Cruise speed and range specifications
  - Turnaround time calculations
  - Maximum flights per week calculations based on route distance
- **Route** (`route.dart`): Comprehensive route management supporting:
  - Multi-aircraft assignments per route
  - Temporary route creation during multi-step process
  - Persistent route storage with unique IDs
  - Capacity calculations across all assigned aircraft
- **Airline** (`airline.dart`): Represents the player's airline company
- **Managers**: Singleton pattern for global state management:
  - **FleetManager** (`services/fleet_manager.dart`): Aircraft fleet management
  - **FinanceManager** (`services/finance_manager.dart`): Capital and financial tracking
  - **RouteManager** (`services/route_manager.dart`): Route persistence and management
- **Aircraft Types** (`aircraft_types/`): Specific aircraft implementations (e.g., A320-200)

#### 2. Screens (`lib/screens/`)
- **HomeScreen** (`home_screen.dart`): Main dashboard showing airports and navigation
- **Route Creation Workflow**:
  - **RouteCreationScreen1** (`route_creation_screen_1.dart`): Airport selection with distance calculation
  - **RouteCreationScreen2** (`route_creation_screen_2.dart`): Multi-aircraft selection interface
  - **RouteCreationScreen3** (`route_creation_screen_3.dart`): Flight frequency with realistic time calculations
  - **RouteCreationScreen4** (`route_creation_screen_4.dart`): Service options and route finalization
- **RoutesOverviewScreen** (`routes_overview_screen.dart`): Manage and view all created routes
- **AircraftPurchaseScreen** (`aircraft_purchase_screen.dart`): Aircraft fleet expansion interface
- **OwnAircraftScreen** (`own_aircraft_screen.dart`): View owned aircraft fleet
- **GameStartScreen** (`game_start_screen.dart`): Initial game setup and capital input
- **AirportSelectionScreen** (`airport_selection_screen.dart`): Airport picker for route planning
- **AirportDetailsScreen** (`airport_details_screen.dart`): Detailed airport information display

#### 3. Widgets (`lib/widgets/`)
- **AirportCard** (`airport_card.dart`): Reusable component for displaying airport information

## ✈️ Current Features

### 🏢 Airport Management
- **Capacity System**: Each airport has slot and terminal capacity with current usage tracking
- **Expansion Options**: Airports can be expanded with proper permissions
- **Location Data**: Airports include city, country, and operational details
- **Utilization Tracking**: Real-time monitoring of airport capacity usage

### 🛫 Aircraft Fleet Management
- **Aircraft Purchase**: Buy new aircraft to expand your fleet
- **Unique Identification**: Each aircraft has a unique ID for tracking and assignment
- **Realistic Specifications**: Aircraft include detailed performance data:
  - Passenger capacity and cargo specifications
  - Range and fuel consumption
  - Cruise speed for flight time calculations
  - Turnaround times for realistic scheduling
- **Fleet Overview**: View all owned aircraft with assignment status
- **Multi-Route Assignment**: Single aircraft can be assigned to multiple routes
- **Performance Calculations**: Automatic calculation of maximum flights per week based on route distance

### 🗺️ Route Planning
- **Multi-Step Route Creation**: Comprehensive 4-step route creation process
  1. **Airport Selection**: Choose departure and destination airports with distance calculation
  2. **Multi-Aircraft Selection**: Select multiple aircraft for a single route
  3. **Flight Frequency**: Set weekly flights based on aircraft capabilities and realistic timing
  4. **Service Options**: Configure onboard services (meals, etc.)
- **Intelligent Calculations**: Realistic flight times including:
  - Cruise speed and flight time calculations
  - Turnaround times at airports
  - Taxi times for takeoff/landing
  - Maximum flights per week based on aircraft performance
- **Route Management**: 
  - View all created routes in organized overview
  - Edit and delete existing routes
  - Aircraft assignment tracking and management
- **Capacity Optimization**: Automatic calculation of passenger capacity across all aircraft on a route

### 💼 Business Operations
- **Ticket Pricing**: Set prices for different passenger classes (Economy, Business)
- **Capacity Management**: Monitor and optimize airport slot usage
- **Fleet Utilization**: Track which aircraft are assigned to which routes

## 🛠️ Technical Implementation

### 📈 Recent Major Improvements

#### 🛣️ Multi-Step Route Creation Workflow
The route creation process has been completely redesigned for better user experience and data integrity:

1. **Airport Selection** (`RouteCreationScreen1`)
   - Choose departure and destination airports
   - Validation to prevent same origin/destination
   - Clear navigation to next step

2. **Aircraft Selection** (`RouteCreationScreen2`)
   - **Multi-selection support**: Choose multiple aircraft for the same route
   - Visual selection indicators with checkboxes
   - Aircraft details display (capacity, range, speed)
   - Intelligent navigation bug fix for selection consistency

3. **Flight Frequency Planning** (`RouteCreationScreen3`)
   - **Realistic weekly calculation** (not daily) based on:
     - Flight distance and aircraft cruise speed
     - Turnaround times (2 hours) and taxi times (30 min each direction)
     - **All selected aircraft** contribute to total capacity
   - Interactive frequency selection with real-time capacity updates
   - Combined aircraft capacity display

4. **Route Confirmation** (`RouteCreationScreen4`)
   - Final review of all route parameters
   - Atomic route persistence (only saved when finalized)
   - Return to routes overview

#### 🏗️ Technical Architecture Improvements
- **Temporary Object Pattern**: Routes are built step-by-step in memory and only persisted when complete
- **Robust State Management**: Each screen properly initializes and maintains state
- **Multi-Aircraft Support**: Complete refactoring to support multiple aircraft per route
- **Singleton Managers**: 
  - `FleetManager`: Global aircraft fleet management
  - `FinanceManager`: Capital and transaction tracking
  - `RouteManager`: Route storage and retrieval
- **Navigation Bug Fixes**: Proper list clearing and re-initialization when navigating between screens

#### ✈️ Aircraft Model & Purchase System Enhancements

**Realistic Aircraft Specifications:**
- **Performance Data**: Added `cruiseSpeed` (km/h) and `turnaroundTimeMinutes` for realistic flight calculations
- **Unique Aircraft IDs**: Each purchased aircraft gets a unique identifier for tracking and assignment
- **Template Pattern**: Consistent aircraft creation from predefined templates with individual instances
- **Range & Capacity**: Detailed specifications including passenger capacity, cargo space, and operational range

**Enhanced Purchase Experience:**
- **Capital Validation**: Real-time checking of available funds before purchase
- **Transaction Processing**: Atomic purchase operations with proper error handling
- **Fleet Integration**: Immediate integration of new aircraft into `FleetManager`
- **Purchase Confirmation**: Clear feedback and navigation after successful purchase
- **Aircraft Cards**: Visual display of aircraft specifications during selection

**FleetManager Singleton:**
- **Global Fleet State**: Centralized management of all owned aircraft
- **Aircraft Assignment**: Track which aircraft are assigned to routes
- **Performance Queries**: Quick access to aircraft by ID, type, or availability status
- **Fleet Statistics**: Overview of total capacity, utilization, and fleet composition

#### ⚡ Performance & User Experience
- **Weekly Flight Logic**: More realistic simulation with proper time calculations
- **Multi-Selection UI**: Intuitive aircraft selection with visual feedback
- **Calculation Accuracy**: All aircraft contribute to route capacity and frequency limits
- **Clean State Management**: Proper cleanup and re-initialization prevents data inconsistencies
- **Real-time Calculations**: Dynamic flight frequency and capacity calculations based on aircraft performance
- **Atomic Operations**: Purchase and route creation are fail-safe with proper rollback capabilities

#### 🎯 Code Quality & Maintainability
- **Singleton Pattern**: Centralized state management for critical game components
- **Template Pattern**: Consistent object creation and initialization
- **Separation of Concerns**: Clear distinction between models, services, and UI components
- **Type Safety**: Strong typing throughout with comprehensive null safety
- **Error Handling**: Robust validation and user feedback mechanisms

### State Management
- Uses Flutter's built-in `StatefulWidget` for local state management
- State is maintained within individual screens
- Data is passed between screens via constructor parameters

### Data Flow
1. **Home Screen** serves as the central hub
2. **Navigation** between screens passes relevant data
3. **State Updates** occur when returning from sub-screens
4. **Capacity Calculations** are performed in real-time

### Code Quality
- **Comprehensive Documentation**: All classes and methods are thoroughly documented
- **English Naming**: Consistent English naming following Flutter conventions
- **Type Safety**: Strong typing throughout the application
- **Error Handling**: Basic validation and user feedback

## 🚀 Future Enhancements

### Planned Features
- **Economic System**: Revenue, costs, and profitability calculations
- **Time Management**: Game time progression and seasonal effects
- **Competition**: AI-controlled competitor airlines
- **Weather System**: Weather effects on operations
- **Data Persistence**: Save and load game progress
- **Financial Management**: Loans, investments, and cash flow

### Technical Improvements
- **State Management**: Implement Provider/Riverpod for better state management
- **Database Integration**: Add local storage with SQLite
- **Performance Optimization**: Implement efficient data structures for large datasets
- **Testing**: Add unit and widget tests
- **Localization**: Multi-language support

## 📱 Platform Support

Currently configured for:
- ✅ **Windows** (Primary target)
- ✅ **Web** (Flutter web support)
- ⚠️ **Android/iOS** (Available but not optimized)

## 🛠️ Development Setup

### Prerequisites
- Flutter SDK 3.7.2 or higher
- Dart SDK
- VS Code or Android Studio

### Getting Started
```bash
# Clone the repository
git clone <repository-url>

# Navigate to project directory
cd beyond_horizons

# Install dependencies
flutter pub get

# Run the application
flutter run
```

### Build Commands
```bash
# For Windows
flutter build windows

# For Web
flutter build web

# Analyze code quality
flutter analyze
```

## 📊 Project Structure Details

### Models Architecture
```dart
// Example: Airport capacity management
class Airport {
  int slotCapacity;           // Total runway slots
  int currentSlotUsage;       // Used slots
  int availableSlotCapacity;  // Calculated available slots
  
  bool checkCapacity() {      // Validation logic
    return currentSlotUsage < slotCapacity;
  }
}
```

### Screen Navigation Flow
```
HomeScreen
├── RouteCreationScreen (create routes)
├── AircraftPurchaseScreen (buy aircraft)
├── AirportSelectionScreen (choose airports)
└── AirportDetailsScreen (view airport info)
```

## 🎮 Gameplay Loop

1. **Start**: Begin with basic airline setup
2. **Purchase Aircraft**: Expand your fleet
3. **Create Routes**: Connect airports with flights
4. **Assign Aircraft**: Allocate planes to routes
5. **Monitor Capacity**: Track airport utilization
6. **Optimize Operations**: Adjust frequency and services

## 📈 Performance Considerations

- **Efficient Calculations**: Real-time capacity calculations are optimized
- **Memory Management**: Proper disposal of controllers and listeners
- **UI Responsiveness**: Non-blocking operations for smooth user experience
- **Scalability**: Architecture supports addition of more airports and aircraft types

## 🤝 Contributing

The codebase is well-documented and follows Flutter best practices, making it easy for new developers to contribute. All code includes comprehensive comments explaining functionality and business logic.

## 📄 License

This project is currently private and not licensed for public distribution.

---

**Beyond Horizons** - Taking airline management simulation to new heights! ✈️
