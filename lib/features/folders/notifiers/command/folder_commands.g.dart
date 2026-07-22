// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder_commands.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FolderCommands)
final folderCommandsProvider = FolderCommandsProvider._();

final class FolderCommandsProvider
    extends $AsyncNotifierProvider<FolderCommands, void> {
  FolderCommandsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'folderCommandsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$folderCommandsHash();

  @$internal
  @override
  FolderCommands create() => FolderCommands();
}

String _$folderCommandsHash() => r'folder_cmd_gen_hash_001';

abstract class _$FolderCommands extends $AsyncNotifier<void> {
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
