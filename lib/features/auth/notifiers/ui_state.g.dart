// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IsPasswordObscure)
const isPasswordObscureProvider = IsPasswordObscureProvider._();

final class IsPasswordObscureProvider
    extends $NotifierProvider<IsPasswordObscure, bool> {
  const IsPasswordObscureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isPasswordObscureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isPasswordObscureHash();

  @$internal
  @override
  IsPasswordObscure create() => IsPasswordObscure();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isPasswordObscureHash() => r'd80b1fb03f8a8af71523b6c32d7c03ed242924ad';

abstract class _$IsPasswordObscure extends $Notifier<bool> {
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

@ProviderFor(IsRepeatPasswordObscure)
const isRepeatPasswordObscureProvider = IsRepeatPasswordObscureProvider._();

final class IsRepeatPasswordObscureProvider
    extends $NotifierProvider<IsRepeatPasswordObscure, bool> {
  const IsRepeatPasswordObscureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isRepeatPasswordObscureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isRepeatPasswordObscureHash();

  @$internal
  @override
  IsRepeatPasswordObscure create() => IsRepeatPasswordObscure();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isRepeatPasswordObscureHash() =>
    r'607d79afc990396d0b12fad930939a5001e7bef1';

abstract class _$IsRepeatPasswordObscure extends $Notifier<bool> {
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
