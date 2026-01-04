import 'dart:convert';
import 'package:native_storage/native_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/services/native_storage.dart';

part 'query_cache_service.g.dart';

/// Service for caching query results locally
/// Provides methods to store and retrieve cached data with automatic JSON serialization
@Riverpod(keepAlive: true)
QueryCacheService queryCacheService(Ref ref) {
  return QueryCacheService(
    storage: ref.read(storageProvider),
  );
}

class QueryCacheService {
  final NativeStorage _storage;
  static const String _cachePrefix = 'query_cache_';

  QueryCacheService({required NativeStorage storage}) : _storage = storage;

  /// Generates a cache key from the provider name
  String _getCacheKey(String providerName) {
    return '$_cachePrefix$providerName';
  }

  /// Stores data in cache as JSON
  /// [providerName] - The name of the provider (used as cache key)
  /// [data] - The data to cache (must be JSON-serializable)
  Future<void> setCache<T>(String providerName, T data) async {
    try {
      final key = _getCacheKey(providerName);
      final jsonString = jsonEncode(data);
      _storage.write(key, jsonString);
    } catch (e) {
      // Silently fail - caching is not critical
      // Log error if needed
    }
  }

  /// Retrieves cached data and deserializes it
  /// Returns null if cache doesn't exist or is invalid
  Future<T?> getCache<T>(String providerName, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final key = _getCacheKey(providerName);
      final jsonString = _storage.read(key);
      
      if (jsonString == null) {
        return null;
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return fromJson(json);
    } catch (e) {
      // Return null if cache is invalid or doesn't exist
      return null;
    }
  }

  /// Clears cache for a specific provider
  /// Note: NativeStorage doesn't have a delete method, so we write an empty string
  Future<void> clearCache(String providerName) async {
    try {
      final key = _getCacheKey(providerName);
      // Write empty string to effectively clear the cache
      _storage.write(key, '');
    } catch (e) {
      // Silently fail
    }
  }

  /// Clears all query caches
  /// Note: NativeStorage doesn't have getAllKeys, so this is a best-effort implementation
  Future<void> clearAllCaches() async {
    // NativeStorage doesn't provide a way to list all keys
    // This would need to be implemented differently if needed
    // For now, we'll just document that individual caches should be cleared
  }

  /// Checks if cache exists for a provider
  Future<bool> hasCache(String providerName) async {
    try {
      final key = _getCacheKey(providerName);
      final value = _storage.read(key);
      return value != null;
    } catch (e) {
      return false;
    }
  }
}

