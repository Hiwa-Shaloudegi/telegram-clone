
import 'package:native_storage/native_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/core/cache/cached_data.dart';
import 'package:telegram_clone/services/native_storage.dart';

part 'query_cache_service.g.dart';

@Riverpod(keepAlive: true)
QueryCacheService queryCacheService(Ref ref) {
  return QueryCacheService(ref.read(storageProvider));
}

/// Central cache management service for query data persistence
class QueryCacheService {
  final NativeStorage _storage;

  QueryCacheService(this._storage);

  /// Get cached data for a key
  /// Returns null if not found or if deserialization fails
  CachedData<T>? get<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    try {
      final jsonString = _storage.read(key);
      if (jsonString == null) return null;
      return CachedData.fromJsonString(jsonString, fromJson);
    } catch (_) {
      return null;
    }
  }

  /// Store data in cache with current timestamp
  void set<T>(String key, T data, Map<String, dynamic> Function(T) toJson) {
    try {
      final cachedData = CachedData(data: data, cachedAt: DateTime.now());
      _storage.write(key, cachedData.toJsonString(toJson));
    } catch (_) {
      // Silently fail on cache write errors
    }
  }

  /// Invalidate (remove) a specific cache entry
  void invalidate(String key) {
    try {
      _storage.delete(key);
    } catch (_) {
      // Silently fail
    }
  }

  /// Invalidate all cache entries matching a prefix
  /// Note: This requires iterating through all keys, use sparingly
  void invalidatePrefix(String prefix) {
    // NativeStorage doesn't support prefix deletion directly
    // This would need to be implemented based on storage capabilities
    // For now, this is a placeholder for future implementation
  }

  /// Clear all query cache entries
  void clear() {
    try {
      _storage.clear();
    } catch (_) {
      // Silently fail
    }
  }

  /// Check if a cached entry exists and is not expired
  bool hasValidCache<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
    Duration staleDuration,
  ) {
    final cached = get(key, fromJson);
    return cached != null && !cached.isExpired(staleDuration);
  }
}
