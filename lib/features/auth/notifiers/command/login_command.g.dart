// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoginCommand)
const loginCommandProvider = LoginCommandProvider._();

final class LoginCommandProvider
    extends $AsyncNotifierProvider<LoginCommand, void> {
  const LoginCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginCommandHash();

  @$internal
  @override
  LoginCommand create() => LoginCommand();
}

String _$loginCommandHash() => r'97019da8a16d75aa93c5bc626722a11d7b5ff23e';

abstract class _$LoginCommand extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
