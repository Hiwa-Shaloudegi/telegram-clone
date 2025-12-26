// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_ui_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoginUi_isPasswordObscure)
const loginUi_isPasswordObscureProvider = LoginUi_isPasswordObscureProvider._();

final class LoginUi_isPasswordObscureProvider
    extends $NotifierProvider<LoginUi_isPasswordObscure, bool> {
  const LoginUi_isPasswordObscureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginUi_isPasswordObscureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginUi_isPasswordObscureHash();

  @$internal
  @override
  LoginUi_isPasswordObscure create() => LoginUi_isPasswordObscure();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$loginUi_isPasswordObscureHash() =>
    r'2a3596f69645db3f88b1e11fddc1d010aca40376';

abstract class _$LoginUi_isPasswordObscure extends $Notifier<bool> {
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
