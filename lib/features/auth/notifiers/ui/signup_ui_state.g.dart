// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_ui_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignupUi_isPasswordObscure)
const signupUi_isPasswordObscureProvider =
    SignupUi_isPasswordObscureProvider._();

final class SignupUi_isPasswordObscureProvider
    extends $NotifierProvider<SignupUi_isPasswordObscure, bool> {
  const SignupUi_isPasswordObscureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signupUi_isPasswordObscureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signupUi_isPasswordObscureHash();

  @$internal
  @override
  SignupUi_isPasswordObscure create() => SignupUi_isPasswordObscure();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$signupUi_isPasswordObscureHash() =>
    r'178bdeaa79bb2f1b6f295148a950eb9657dab04a';

abstract class _$SignupUi_isPasswordObscure extends $Notifier<bool> {
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

@ProviderFor(SignupUi_isRepeatPasswordObscure)
const signupUi_isRepeatPasswordObscureProvider =
    SignupUi_isRepeatPasswordObscureProvider._();

final class SignupUi_isRepeatPasswordObscureProvider
    extends $NotifierProvider<SignupUi_isRepeatPasswordObscure, bool> {
  const SignupUi_isRepeatPasswordObscureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signupUi_isRepeatPasswordObscureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signupUi_isRepeatPasswordObscureHash();

  @$internal
  @override
  SignupUi_isRepeatPasswordObscure create() =>
      SignupUi_isRepeatPasswordObscure();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$signupUi_isRepeatPasswordObscureHash() =>
    r'fa9240f4cdcb0e7e49ee66917f9d1f46ad980b19';

abstract class _$SignupUi_isRepeatPasswordObscure extends $Notifier<bool> {
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
