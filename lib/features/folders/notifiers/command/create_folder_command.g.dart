// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_folder_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateFolderCommand)
final createFolderCommandProvider = CreateFolderCommandProvider._();

final class CreateFolderCommandProvider
    extends $AsyncNotifierProvider<CreateFolderCommand, void> {
  CreateFolderCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createFolderCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createFolderCommandHash();

  @$internal
  @override
  CreateFolderCommand create() => CreateFolderCommand();
}

String _$createFolderCommandHash() =>
    r'2584738a3699ca18b0f46638b8096896f3108429';

abstract class _$CreateFolderCommand extends $AsyncNotifier<void> {
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
