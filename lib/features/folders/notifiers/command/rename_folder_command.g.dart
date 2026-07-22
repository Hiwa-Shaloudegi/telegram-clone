// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rename_folder_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RenameFolderCommand)
final renameFolderCommandProvider = RenameFolderCommandProvider._();

final class RenameFolderCommandProvider
    extends $AsyncNotifierProvider<RenameFolderCommand, void> {
  RenameFolderCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'renameFolderCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$renameFolderCommandHash();

  @$internal
  @override
  RenameFolderCommand create() => RenameFolderCommand();
}

String _$renameFolderCommandHash() =>
    r'8a6d2fc3a6cff4568dfb175f350272a5aca7609d';

abstract class _$RenameFolderCommand extends $AsyncNotifier<void> {
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
