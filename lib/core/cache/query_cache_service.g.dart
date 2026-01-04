// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_cache_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Service for caching query results locally
/// Provides methods to store and retrieve cached data with automatic JSON serialization

@ProviderFor(queryCacheService)
const queryCacheServiceProvider = QueryCacheServiceProvider._();

/// Service for caching query results locally
/// Provides methods to store and retrieve cached data with automatic JSON serialization

final class QueryCacheServiceProvider
    extends
        $FunctionalProvider<
          QueryCacheService,
          QueryCacheService,
          QueryCacheService
        >
    with $Provider<QueryCacheService> {
  /// Service for caching query results locally
  /// Provides methods to store and retrieve cached data with automatic JSON serialization
  const QueryCacheServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queryCacheServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queryCacheServiceHash();

  @$internal
  @override
  $ProviderElement<QueryCacheService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  QueryCacheService create(Ref ref) {
    return queryCacheService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QueryCacheService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QueryCacheService>(value),
    );
  }
}

String _$queryCacheServiceHash() => r'effc05dc06b7e4ea2b6df7406803668cef2c88f2';
