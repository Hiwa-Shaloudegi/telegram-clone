// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_with_google_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoginWithGoogleCommand)
final loginWithGoogleCommandProvider = LoginWithGoogleCommandProvider._();

final class LoginWithGoogleCommandProvider
    extends $AsyncNotifierProvider<LoginWithGoogleCommand, void> {
  LoginWithGoogleCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginWithGoogleCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginWithGoogleCommandHash();

  @$internal
  @override
  LoginWithGoogleCommand create() => LoginWithGoogleCommand();
}

String _$loginWithGoogleCommandHash() =>
    r'816c9ffb59306e3133ecc2ba6ac70ee3a4fcd04b';

abstract class _$LoginWithGoogleCommand extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
