// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_settings_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(privacySettingsApi)
const privacySettingsApiProvider = PrivacySettingsApiProvider._();

final class PrivacySettingsApiProvider
    extends
        $FunctionalProvider<
          PrivacySettingsApi,
          PrivacySettingsApi,
          PrivacySettingsApi
        >
    with $Provider<PrivacySettingsApi> {
  const PrivacySettingsApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'privacySettingsApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$privacySettingsApiHash();

  @$internal
  @override
  $ProviderElement<PrivacySettingsApi> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PrivacySettingsApi create(Ref ref) {
    return privacySettingsApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrivacySettingsApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrivacySettingsApi>(value),
    );
  }
}

String _$privacySettingsApiHash() =>
    r'9b8c3512c9462d40fcc699431777e5f48a25c64a';
