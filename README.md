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
- **Aircraft** (`aircraft.dart`): Base class for aircraft with specifications like capacity, range, and fuel consumption
- **Airline** (`airline.dart`): Represents the player's airline company with route management
- **FlightRoute** (`route.dart`): Manages flight connections between airports with capacity calculations
- **Aircraft Types** (`aircraft_types/`): Specific aircraft implementations (e.g., A320-200)

#### 2. Screens (`lib/screens/`)
- **HomeScreen** (`home_screen.dart`): Main dashboard showing airports and navigation
- **RouteCreationScreen** (`route_creation_screen.dart`): Interface for creating new flight routes
- **AircraftPurchaseScreen** (`aircraft_purchase_screen.dart`): Aircraft fleet expansion interface
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
- **Unique Identification**: Each aircraft has a unique ID for tracking
- **Specifications**: Aircraft include realistic data (capacity, range, fuel consumption)
- **Fleet Overview**: View all owned aircraft with their specifications

### 🗺️ Route Planning
- **Route Creation**: Establish flight connections between airports
- **Aircraft Assignment**: Assign specific aircraft to routes
- **Frequency Control**: Set flights per week (0-21 flights)
- **Service Options**: Choose whether to provide onboard services
- **Capacity Calculation**: Automatic calculation of route passenger capacity

### 💼 Business Operations
- **Ticket Pricing**: Set prices for different passenger classes (Economy, Business)
- **Capacity Management**: Monitor and optimize airport slot usage
- **Fleet Utilization**: Track which aircraft are assigned to which routes

## 🛠️ Technical Implementation

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
