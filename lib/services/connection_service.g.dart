// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(connectivityStream)
const connectivityStreamProvider = ConnectivityStreamProvider._();

final class ConnectivityStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ConnectivityResult>>,
          List<ConnectivityResult>,
          Stream<List<ConnectivityResult>>
        >
    with
        $FutureModifier<List<ConnectivityResult>>,
        $StreamProvider<List<ConnectivityResult>> {
  const ConnectivityStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<ConnectivityResult>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ConnectivityResult>> create(Ref ref) {
    return connectivityStream(ref);
  }
}

String _$connectivityStreamHash() =>
    r'63b6e0e427b796cdff6b172cd47ea2b1a7aca8cc';

@ProviderFor(channelStatusStream)
const channelStatusStreamProvider = ChannelStatusStreamProvider._();

final class ChannelStatusStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<RealtimeSubscribeStatus>,
          RealtimeSubscribeStatus,
          Stream<RealtimeSubscribeStatus>
        >
    with
        $FutureModifier<RealtimeSubscribeStatus>,
        $StreamProvider<RealtimeSubscribeStatus> {
  const ChannelStatusStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'channelStatusStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$channelStatusStreamHash();

  @$internal
  @override
  $StreamProviderElement<RealtimeSubscribeStatus> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<RealtimeSubscribeStatus> create(Ref ref) {
    return channelStatusStream(ref);
  }
}

String _$channelStatusStreamHash() =>
    r'5f5e3364ed2dce2d3073cc4be79f7af1a450c9bc';

@ProviderFor(IsSyncing)
const isSyncingProvider = IsSyncingProvider._();

final class IsSyncingProvider extends $NotifierProvider<IsSyncing, bool> {
  const IsSyncingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isSyncingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isSyncingHash();

  @$internal
  @override
  IsSyncing create() => IsSyncing();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isSyncingHash() => r'6af690ac3004fc9a5774158d6c1572be9bf8741a';

abstract class _$IsSyncing extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(appConnectionStatus)
const appConnectionStatusProvider = AppConnectionStatusProvider._();

final class AppConnectionStatusProvider
    extends
        $FunctionalProvider<
          TelegramConnectionState,
          TelegramConnectionState,
          TelegramConnectionState
        >
    with $Provider<TelegramConnectionState> {
  const AppConnectionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appConnectionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appConnectionStatusHash();

  @$internal
  @override
  $ProviderElement<TelegramConnectionState> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TelegramConnectionState create(Ref ref) {
    return appConnectionStatus(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TelegramConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TelegramConnectionState>(value),
    );
  }
}

String _$appConnectionStatusHash() =>
    r'47996902820e291c7838374a41e2873ae6067071';
