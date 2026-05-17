// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignupCommand)
final signupCommandProvider = SignupCommandProvider._();

final class SignupCommandProvider
    extends $AsyncNotifierProvider<SignupCommand, void> {
  SignupCommandProvider._()
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

String _$signupCommandHash() => r'1331380ebbf188b37122df8128e7b3d1da864ec4';

abstract class _$SignupCommand extends $AsyncNotifier<void> {
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
