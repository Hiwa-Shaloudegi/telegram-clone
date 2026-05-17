// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_username_availability_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CheckUsernameAvailabilityCommand)
final checkUsernameAvailabilityCommandProvider =
    CheckUsernameAvailabilityCommandProvider._();

final class CheckUsernameAvailabilityCommandProvider
    extends $AsyncNotifierProvider<CheckUsernameAvailabilityCommand, bool?> {
  CheckUsernameAvailabilityCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkUsernameAvailabilityCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkUsernameAvailabilityCommandHash();

  @$internal
  @override
  CheckUsernameAvailabilityCommand create() =>
      CheckUsernameAvailabilityCommand();
}

String _$checkUsernameAvailabilityCommandHash() =>
    r'3bae8d23b23f72250888f5d0cb111f258054ca95';

abstract class _$CheckUsernameAvailabilityCommand
    extends $AsyncNotifier<bool?> {
  FutureOr<bool?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool?>, bool?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool?>, bool?>,
              AsyncValue<bool?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
