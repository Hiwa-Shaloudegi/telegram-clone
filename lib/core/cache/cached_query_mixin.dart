import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/core/cache/query_cache_service.dart';

/// Mixin that provides caching functionality for Riverpod queries
/// 
/// Usage:
/// ```dart
/// @Riverpod(keepAlive: true)
/// class UserProfileQuery extends _$UserProfileQuery with CachedQueryMixin<UserProfile> {
///   @override
///   String get cacheKey => 'userProfileQuery';
///   
///   @override
///   FutureOr<UserProfile> build() async {
///     return await buildWithCache(
///       fetcher: () => ref.read(userApiProvider).getUserProfile(),
///       fromJson: (json) => UserProfile.fromJson(json),
///       toJson: (data) => data.toJson(),
///     );
///   }
/// }
/// ```
mixin CachedQueryMixin<T> {
  /// The cache key for this query (should be unique per query)
  /// Override this in your query class
  String get cacheKey;
  
  /// Reference to the provider (must be provided by the implementing class)
  Ref get ref;
  
  /// State setter (must be provided by the implementing class)
  set state(AsyncValue<T> value);

  /// Builds the query with caching support
  /// 
  /// [fetcher] - The function that fetches fresh data from the network
  /// [fromJson] - Function to deserialize cached JSON to your data type
  /// [toJson] - Function to serialize your data type to JSON
  Future<T> buildWithCache({
    required Future<T> Function() fetcher,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
  }) async {
    final cacheService = ref.read(queryCacheServiceProvider);
    
    // Try to load from cache first
    final cachedData = await cacheService.getCache<T>(cacheKey, fromJson);
    
    // If cache exists, emit it immediately and then fetch fresh data
    if (cachedData != null) {
      // Set the cached data as the initial state
      // This will be updated when fresh data arrives
      state = AsyncValue.data(cachedData);
      
      // Fetch fresh data in the background (don't await)
      unawaited(_fetchAndUpdateCache(
        fetcher: fetcher,
        toJson: toJson,
        cacheService: cacheService,
      ));
      
      return cachedData;
    }
    
    // No cache exists, fetch fresh data
    try {
      final freshData = await fetcher();
      
      // Cache the fresh data
      await cacheService.setCache(cacheKey, toJson(freshData));
      
      return freshData;
    } catch (e) {
      // If we have cached data, return it even if fresh fetch fails
      // Note: cachedData is null here since we're in the else branch
      // Re-throw the error since there's no cache to fall back to
      rethrow;
    }
  }

  /// Fetches fresh data and updates both state and cache
  Future<void> _fetchAndUpdateCache({
    required Future<T> Function() fetcher,
    required Map<String, dynamic> Function(T) toJson,
    required QueryCacheService cacheService,
  }) async {
    try {
      final freshData = await fetcher();
      
      // Update state with fresh data
      state = AsyncValue.data(freshData);
      
      // Update cache with fresh data
      await cacheService.setCache(cacheKey, toJson(freshData));
    } catch (e) {
      // If fetch fails, keep the cached data (already set in state)
      // Optionally, you could emit an error here if you want to show
      // that the data might be stale
    }
  }

  /// Manually refresh the data (useful for pull-to-refresh)
  Future<void> refreshData({
    required Future<T> Function() fetcher,
    required Map<String, dynamic> Function(T) toJson,
  }) async {
    final cacheService = ref.read(queryCacheServiceProvider);
    
    state = const AsyncValue.loading();
    
    try {
      final freshData = await fetcher();
      state = AsyncValue.data(freshData);
      await cacheService.setCache(cacheKey, toJson(freshData));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Clears the cache for this query
  Future<void> clearCache() async {
    final cacheService = ref.read(queryCacheServiceProvider);
    await cacheService.clearCache(cacheKey);
  }
}

/// Helper function to avoid awaiting background tasks
void unawaited(Future<void> future) {
  // Intentionally not awaiting
}

