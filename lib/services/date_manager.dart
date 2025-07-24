import 'package:flutter/material.dart';

/// Singleton manager for global game date
/// Ensures all screens show the same current month/year
class DateManager {
  static final DateManager _instance = DateManager._internal();
  factory DateManager() => _instance;
  DateManager._internal();

  // Global game date (starts January 2025)
  int currentMonth = 1; // Januar
  int currentYear = 2025;

  // Listeners for date changes
  final List<VoidCallback> _listeners = [];

  // German month names for display
  final List<String> monthNames = [
    'Januar',
    'Februar',
    'März',
    'April',
    'Mai',
    'Juni',
    'Juli',
    'August',
    'September',
    'Oktober',
    'November',
    'Dezember',
  ];

  /// Add a listener that gets called when date changes
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  /// Remove a listener
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// Notify all listeners of date change
  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  /// Advance to next month and handle year rollover
  void advanceToNextMonth() {
    currentMonth++;
    if (currentMonth > 12) {
      currentMonth = 1;
      currentYear++;
    }
    _notifyListeners(); // Notify all screens of the change
  }

  /// Get number of active listeners (for testing/debugging)
  int get listenerCount => _listeners.length;

  /// Get current month name in German
  String getCurrentMonthName() {
    return monthNames[currentMonth - 1];
  }

  /// Get formatted date string
  String getFormattedDate() {
    return "${getCurrentMonthName()} $currentYear";
  }

  /// Reset date to initial values (for testing/debugging)
  void reset() {
    currentMonth = 1;
    currentYear = 2025;
  }
}
