import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static AppLogger? _instance;
  late Logger _logger;

  AppLogger._() {
    _logger = Logger(
      filter: kDebugMode ? DevelopmentFilter() : ProductionFilter(),
      printer:
          kDebugMode
              ? PrettyPrinter(
                methodCount: 2, // Number of method calls to be displayed
                errorMethodCount:
                    8, // Number of method calls if stacktrace is provided
                lineLength: 120, // Width of the output
                colors: true, // Colorful log messages
                printEmojis: true, // Print an emoji for each log message
                printTime: true, // Should each log print contain a timestamp
              )
              : SimplePrinter(colors: false), // Simpler output for production
      output: ConsoleOutput(), // Where to send the log messages
    );
  }

  static AppLogger get instance {
    _instance ??= AppLogger._();
    return _instance!;
  }

  // Trace level - Most verbose, for detailed debugging
  void t(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  // Debug level - Debug information
  void d(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  // Info level - General information
  void i(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  // Warning level - Warning messages
  void w(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  // Error level - Error messages
  void e(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  // Fatal level - Fatal error messages
  void f(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}

// Global logger instance for easy access
final logger = AppLogger.instance;
