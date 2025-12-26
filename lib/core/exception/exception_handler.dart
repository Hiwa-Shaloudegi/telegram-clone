import 'dart:io';

import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telegram_clone/core/exception/app_exception.dart';
import 'package:telegram_clone/core/exception/timeout_exception.dart';
import 'package:telegram_clone/core/logger/logger.dart';

part 'exception_handler.g.dart';

@Riverpod(keepAlive: true)
ExceptionHandler exceptionHandler(Ref ref) {
  return ExceptionHandler(ref.read(loggerProvider));
}

class ExceptionHandler {
  final Logger _logger;

  ExceptionHandler(this._logger);

  Never handle(dynamic error, [StackTrace? stackTrace]) {
    _logException(error, stackTrace);
    final userMessage = _getUserFriendlyMessage(error);

    throw AppException(
      message: error.toString(),
      userMessage: userMessage,
      originalError: error,
    );
  }

  String getMessage(dynamic error) {
    return _getUserFriendlyMessage(error);
  }

  static String _getUserFriendlyMessage(dynamic error) {
    // Supabase Exceptions
    if (error is AuthException) {
      return _handleAuthException(error);
    }

    if (error is PostgrestException) {
      return _handlePostgrestException(error);
    }

    if (error is StorageException) {
      return _handleStorageException(error);
    }

    if (error is FunctionException) {
      return _handleFunctionException(error);
    }

    // Network Exceptions
    if (error is SocketException) {
      return 'No internet connection. Please check your network and try again.';
    }

    if (error is HttpException) {
      return 'Unable to connect to the server. Please try again later.';
    }

    if (error is FormatException) {
      return 'Invalid data format received. Please contact support.';
    }

    if (error is TimeoutException) {
      return 'Request timed out. Please check your connection and try again.';
    }

    // Custom App Exceptions
    if (error is AppException) {
      return error.userMessage ?? error.message;
    }

    // Generic Exception
    return 'Something went wrong. Please try again later.';
  }

  static String _handleAuthException(AuthException error) {
    switch (error.statusCode) {
      case '400':
        if (error.message.contains('Invalid login credentials')) {
          return 'Invalid email or password. Please try again.';
        }
        if (error.message.contains('Email not confirmed')) {
          return 'Please verify your email address before logging in.';
        }
        if (error.message.contains('User already registered')) {
          return 'An account with this email already exists.';
        }
        return 'Invalid request. Please check your information.';

      case '401':
        return 'Your session has expired. Please log in again.';

      case '403':
        return 'You don\'t have permission to perform this action.';

      case '422':
        if (error.message.contains('Email rate limit exceeded')) {
          return 'Too many requests. Please wait a moment before trying again.';
        }
        if (error.message.contains('Password')) {
          return 'Password must be at least 6 characters long.';
        }
        if (error.message.contains('User already registered')) {
          return 'An account with this email already exists.';
        }
        return 'Unable to process your request. Please check your information.';

      case '429':
        return 'Too many attempts. Please wait a few minutes and try again.';

      case '500':
        return 'Server error. Please try again later.';

      default:
        if (error.message.contains('network')) {
          return 'Network error. Please check your connection.';
        }
        return 'Authentication failed. Please try again.';
    }
  }

  static String _handlePostgrestException(PostgrestException error) {
    final code = error.code;
    final message = error.message.toLowerCase();

    // PostgreSQL Error Codes
    if (code == '23505') {
      return 'This item already exists. Please use a different value.';
    }

    if (code == '23503') {
      return 'Unable to perform this action. Related data may be missing.';
    }

    if (code == '23502') {
      return 'Required information is missing. Please fill in all fields.';
    }

    if (code == '42501') {
      return 'You don\'t have permission to access this data.';
    }

    if (code == '42P01') {
      return 'Data source not found. Please contact support.';
    }

    // Common database errors
    if (message.contains('permission denied') ||
        message.contains('insufficient privilege')) {
      return 'You don\'t have permission to perform this action.';
    }

    if (message.contains('not found') || message.contains('no rows')) {
      return 'The requested data was not found.';
    }

    if (message.contains('duplicate') || message.contains('unique')) {
      return 'This item already exists.';
    }

    if (message.contains('foreign key')) {
      return 'Unable to delete. This item is being used elsewhere.';
    }

    return 'Database error. Please try again later.';
  }

  static String _handleStorageException(StorageException error) {
    final message = error.message.toLowerCase();
    final statusCode = error.statusCode;

    if (statusCode == '404') {
      return 'File not found.';
    }

    if (statusCode == '413') {
      return 'File is too large. Please choose a smaller file.';
    }

    if (statusCode == '400') {
      if (message.contains('mime') || message.contains('type')) {
        return 'Invalid file type. Please choose a different file.';
      }
      return 'Invalid file. Please check and try again.';
    }

    if (statusCode == '401' || statusCode == '403') {
      return 'You don\'t have permission to access this file.';
    }

    if (message.contains('bucket')) {
      return 'Storage location not found. Please contact support.';
    }

    if (message.contains('exceeded') || message.contains('quota')) {
      return 'Storage limit exceeded. Please free up some space.';
    }

    return 'Unable to process file. Please try again.';
  }

  static String _handleFunctionException(FunctionException error) {
    final details = error.details;

    if (details != null && details.toString().contains('timeout')) {
      return 'Operation took too long. Please try again.';
    }

    if (error.status == 400) {
      return 'Invalid request. Please check your information.';
    }

    if (error.status == 401 || error.status == 403) {
      return 'You don\'t have permission to perform this action.';
    }

    if (error.status == 500) {
      return 'Server error. Please try again later.';
    }

    return 'Unable to complete the operation. Please try again.';
  }

  void _logException(dynamic error, StackTrace? stackTrace) {
    if (error is AuthException) {
      _logger.e(
        'Auth Exception [${error.statusCode}]',
        error: error,
        stackTrace: stackTrace,
      );
    } else if (error is PostgrestException) {
      _logger.e(
        'Database Exception [${error.code}]: ${error.message}',
        error: error,
        stackTrace: stackTrace,
      );
    } else if (error is StorageException) {
      _logger.e(
        'Storage Exception [${error.statusCode}]',
        error: error,
        stackTrace: stackTrace,
      );
    } else if (error is FunctionException) {
      _logger.e(
        'Function Exception [${error.status}]',
        error: error,
        stackTrace: stackTrace,
      );
    } else if (error is SocketException) {
      _logger.w(
        'Network Exception: No internet connection',
        error: error,
        stackTrace: stackTrace,
      );
    } else if (error is TimeoutException) {
      _logger.w('Timeout Exception', error: error, stackTrace: stackTrace);
    } else {
      _logger.e(
        'Unhandled Exception: ${error.runtimeType}',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
