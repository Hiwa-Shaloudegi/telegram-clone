// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UpdateProfileCommand)
final updateProfileCommandProvider = UpdateProfileCommandProvider._();

final class UpdateProfileCommandProvider
    extends $AsyncNotifierProvider<UpdateProfileCommand, void> {
  UpdateProfileCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateProfileCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateProfileCommandHash();

  @$internal
  @override
  UpdateProfileCommand create() => UpdateProfileCommand();
}

String _$updateProfileCommandHash() =>
    r'150bd1c58b12e1897175f935048f87f171adbc53';

abstract class _$UpdateProfileCommand extends $AsyncNotifier<void> {
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
