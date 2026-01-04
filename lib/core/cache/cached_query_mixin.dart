
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/core/cache/query_cache_service.dart';

/// Mixin for implementing "Stale-While-Revalidate" caching pattern
///
/// **Pattern:**
/// 1. Immediately return cached data if available (instant UI)
/// 2. Fetch fresh data from network in background
/// 3. Update UI and persist new data to cache
///
/// **Usage:**
/// ```dart
/// @Riverpod(keepAlive: true)
/// class CurrentUser extends _$CurrentUser with CachedQueryMixin<UserModel> {
///   @override
///   String get cacheKey => 'current_user';
///
///   @override
///   UserModel fromJson(Map<String, dynamic> json) => UserModel.fromJson(json);
///
///   @override
///   Map<String, dynamic> toJson(UserModel data) => data.toJson();
///
///   @override
///   Future<UserModel> fetchFromNetwork() => api.getUser();
///
///   @override
///   Future<UserModel> build() => buildCached();
/// }
/// ```
mixin CachedQueryMixin<T> {
  /// Reference to the provider (provided by AsyncNotifier)
  Ref get ref;

  /// Current state (provided by AsyncNotifier)
  AsyncValue<T> get state;
  set state(AsyncValue<T> newState);

  /// Unique key for caching this query's data
  String get cacheKey;

  /// Duration before cached data is considered stale
  /// Even distinct from stale data, we always try to fetch fresh
  Duration get staleDuration => const Duration(minutes: 5);

  /// Helper to access cache service
  QueryCacheService get _cacheService => ref.read(queryCacheServiceProvider);

  /// Transform JSON to Data
  T fromJson(Map<String, dynamic> json);

  /// Transform Data to JSON
  Map<String, dynamic> toJson(T data);

  /// Fetch fresh data from network mechanism
  Future<T> fetchFromNetwork();

  /// Call this in your [build()] method to enable caching behavior
  Future<T> buildCached() async {
    // 1. Try to load from cache first
    final cached = _cacheService.get(cacheKey, fromJson);

    // If we have cache, we can return it immediately
    if (cached != null) {
      // If it's stale or we just want fresh data, trigger a background refresh
      // We assume we always want fresh data in this pattern
      _fetchAndCacheBackground();

      return cached.data;
    }

    // 2. If no cache, perform normal network fetch
    final freshData = await fetchFromNetwork();

    // 3. Cache the new data
    _cacheService.set(cacheKey, freshData, toJson);

    return freshData;
  }

  /// Fetch fresh data in the background and update state
  Future<void> _fetchAndCacheBackground() async {
    try {
      final freshData = await fetchFromNetwork();

      // Update cache
      _cacheService.set(cacheKey, freshData, toJson);

      // Update state if mounted
      state = AsyncData(freshData);
    } catch (e) {
      // If background refresh fails:
      // - If we have cached data displayed, usually we don't disrupt the user with a full error screen
      // - You could choose to show a snackbar or silent failure
      // - Current default: keep showing cached data, maybe log error
      // Note: State remains AsyncData(cached)
    }
  }

  /// Force refresh (bypass cache and reload)
  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final freshData = await fetchFromNetwork();
      _cacheService.set(cacheKey, freshData, toJson);
      state = AsyncData(freshData);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Clear cache for this query
  void invalidateCache() {
    _cacheService.invalidate(cacheKey);
  }
}
