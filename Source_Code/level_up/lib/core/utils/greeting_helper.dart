// =============================================================================
// Core Utility - Greeting Helper
// =============================================================================
// Time-based greeting text generator (Good morning / afternoon / evening).
// =============================================================================

/// Helper to generate contextual greetings based on the time of day.
class GreetingHelper {
  GreetingHelper._();

  /// Returns greeting string based on the provided [dateTime] (defaults to DateTime.now()).
  ///
  /// Intervals:
  /// - 00:00 - 04:59 (0-4): 'Still up?'
  /// - 05:00 - 11:59 (5-11): 'Good morning.'
  /// - 12:00 - 16:59 (12-16): 'Good afternoon.'
  /// - 17:00 - 20:59 (17-20): 'Good evening.'
  /// - 21:00 - 23:59 (21-23): 'Winding down?'
  static String getGreeting([DateTime? dateTime]) {
    final now = dateTime ?? DateTime.now();
    final hour = now.hour;

    if (hour >= 0 && hour <= 4) {
      return 'Still up?';
    } else if (hour >= 5 && hour <= 11) {
      return 'Good morning.';
    } else if (hour >= 12 && hour <= 16) {
      return 'Good afternoon.';
    } else if (hour >= 17 && hour <= 20) {
      return 'Good evening.';
    } else {
      return 'Winding down?';
    }
  }
}
