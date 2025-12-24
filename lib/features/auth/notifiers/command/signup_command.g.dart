// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignupCommand)
const signupCommandProvider = SignupCommandProvider._();

final class SignupCommandProvider
    extends $AsyncNotifierProvider<SignupCommand, void> {
  const SignupCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signupCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signupCommandHash();

  @$internal
  @override
  SignupCommand create() => SignupCommand();
}

String _$signupCommandHash() => r'97000b8d975f27108565747b110958b1d8283fed';

abstract class _$SignupCommand extends $AsyncNotifier<void> {
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
