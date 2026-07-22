// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_folder_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeleteFolderCommand)
final deleteFolderCommandProvider = DeleteFolderCommandProvider._();

final class DeleteFolderCommandProvider
    extends $AsyncNotifierProvider<DeleteFolderCommand, void> {
  DeleteFolderCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteFolderCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteFolderCommandHash();

  @$internal
  @override
  DeleteFolderCommand create() => DeleteFolderCommand();
}

String _$deleteFolderCommandHash() =>
    r'61e154488f2991c75ff352be4e0f4d6a23b4b14d';

abstract class _$DeleteFolderCommand extends $AsyncNotifier<void> {
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
