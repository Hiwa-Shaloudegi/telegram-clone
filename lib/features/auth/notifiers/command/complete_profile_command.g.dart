// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_profile_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CompleteProfileCommand)
const completeProfileCommandProvider = CompleteProfileCommandProvider._();

final class CompleteProfileCommandProvider
    extends $AsyncNotifierProvider<CompleteProfileCommand, void> {
  const CompleteProfileCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completeProfileCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completeProfileCommandHash();

  @$internal
  @override
  CompleteProfileCommand create() => CompleteProfileCommand();
}

String _$completeProfileCommandHash() =>
    r'58f39a222ba638c6eec76122dda05b3bf1fb8fca';

abstract class _$CompleteProfileCommand extends $AsyncNotifier<void> {
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
