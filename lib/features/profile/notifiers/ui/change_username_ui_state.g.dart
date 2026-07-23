// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_username_ui_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChangeUsername_status)
final changeUsername_statusProvider = ChangeUsername_statusProvider._();

final class ChangeUsername_statusProvider
    extends $NotifierProvider<ChangeUsername_status, UsernameStatus> {
  ChangeUsername_statusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changeUsername_statusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changeUsername_statusHash();

  @$internal
  @override
  ChangeUsername_status create() => ChangeUsername_status();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UsernameStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UsernameStatus>(value),
    );
  }
}

String _$changeUsername_statusHash() =>
    r'ad74fb36eacc20017d91a3dd906920cbc9565bf0';

abstract class _$ChangeUsername_status extends $Notifier<UsernameStatus> {
  UsernameStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<UsernameStatus, UsernameStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UsernameStatus, UsernameStatus>,
              UsernameStatus,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ChangeUsername_statusMessage)
final changeUsername_statusMessageProvider =
    ChangeUsername_statusMessageProvider._();

final class ChangeUsername_statusMessageProvider
    extends $NotifierProvider<ChangeUsername_statusMessage, String?> {
  ChangeUsername_statusMessageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changeUsername_statusMessageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changeUsername_statusMessageHash();

  @$internal
  @override
  ChangeUsername_statusMessage create() => ChangeUsername_statusMessage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$changeUsername_statusMessageHash() =>
    r'26f881c1b81eedd78b4b03ad6d963732dcc7fbe4';

abstract class _$ChangeUsername_statusMessage extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
