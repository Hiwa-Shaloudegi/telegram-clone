// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presence_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PresenceService)
const presenceServiceProvider = PresenceServiceProvider._();

final class PresenceServiceProvider
    extends $NotifierProvider<PresenceService, void> {
  const PresenceServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'presenceServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$presenceServiceHash();

  @$internal
  @override
  PresenceService create() => PresenceService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$presenceServiceHash() => r'61eebdce6361a41d081ec80c49a33266805ff106';

abstract class _$PresenceService extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
