import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../common/logger/app_logger.dart';
import '../localization/app_localization_extension.dart';

class ErrorHandler {
  static const Map<String, String> _errorMappings = {
    // Network errors
    'connection': 'error_connection',
    'timeout': 'error_timeout',
    'network': 'error_network',

    // Authentication errors
    'unauthorized': 'error_unauthorized',
    'forbidden': 'error_forbidden',
    'invalid_credentials': 'error_invalid_credentials',
    'token_expired': 'error_token_expired',

    // Server errors
    'internal_error': 'error_internal_error',
    'service_unavailable': 'error_service_unavailable',
    'bad_gateway': 'error_bad_gateway',

    // Chat specific errors
    'empty_response': 'error_empty_response',
    'processing_error': 'error_processing_error',
    'voice_error': 'error_voice_error',

    // General errors
    'unknown': 'error_unknown',
    'validation': 'error_validation',
  };

  /// Converts raw error messages to user-friendly localized messages
  /// Logs detailed error information for debugging
  static String getUserFriendlyMessage(BuildContext context, dynamic error) {
    // Log the original error for debugging (only in debug mode)
    if (kDebugMode) {
      AppLogger.instance.e('Raw error: $error');
    } else {
      // In production, log minimal info
      AppLogger.instance.e('Error occurred: ${error.runtimeType}');
    }

    String rawError = error.toString().toLowerCase();
    String errorKey;

    // Check for specific error patterns
    if (rawError.contains('connection') || rawError.contains('socket')) {
      errorKey = _errorMappings['connection']!;
    } else if (rawError.contains('timeout')) {
      errorKey = _errorMappings['timeout']!;
    } else if (rawError.contains('unauthorized') || rawError.contains('401')) {
      errorKey = _errorMappings['unauthorized']!;
    } else if (rawError.contains('forbidden') || rawError.contains('403')) {
      errorKey = _errorMappings['forbidden']!;
    } else if (rawError.contains('internal server') ||
        rawError.contains('500')) {
      errorKey = _errorMappings['internal_error']!;
    } else if (rawError.contains('service unavailable') ||
        rawError.contains('503')) {
      errorKey = _errorMappings['service_unavailable']!;
    } else if (rawError.contains('bad gateway') || rawError.contains('502')) {
      errorKey = _errorMappings['bad_gateway']!;
    } else if (rawError.contains('empty') || rawError.contains('null')) {
      errorKey = _errorMappings['empty_response']!;
    } else if (rawError.contains('validation') ||
        rawError.contains('invalid')) {
      errorKey = _errorMappings['validation']!;
    } else {
      // Default fallback
      errorKey = _errorMappings['unknown']!;
    }

    return context.l10n.translate(errorKey);
  }

  /// Get specific localized error message by key
  static String getErrorMessage(BuildContext context, String key) {
    final errorKey = _errorMappings[key] ?? _errorMappings['unknown']!;
    return context.l10n.translate(errorKey);
  }

  /// Check if an error indicates authentication issues
  static bool isAuthError(dynamic error) {
    String rawError = error.toString().toLowerCase();
    return rawError.contains('unauthorized') ||
        rawError.contains('401') ||
        rawError.contains('token') ||
        rawError.contains('expired');
  }

  /// Check if error is network related
  static bool isNetworkError(dynamic error) {
    String rawError = error.toString().toLowerCase();
    return rawError.contains('connection') ||
        rawError.contains('network') ||
        rawError.contains('socket') ||
        rawError.contains('timeout');
  }
}
