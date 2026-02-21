// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_cache_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(queryCacheService)
const queryCacheServiceProvider = QueryCacheServiceProvider._();

final class QueryCacheServiceProvider
    extends
        $FunctionalProvider<
          QueryCacheService,
          QueryCacheService,
          QueryCacheService
        >
    with $Provider<QueryCacheService> {
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

String _$queryCacheServiceHash() => r'8ece9dc33e76650149e001eec3fccd2a208309c2';
