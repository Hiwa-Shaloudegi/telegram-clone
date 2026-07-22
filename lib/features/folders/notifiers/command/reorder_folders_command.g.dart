// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reorder_folders_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReorderFoldersCommand)
final reorderFoldersCommandProvider = ReorderFoldersCommandProvider._();

final class ReorderFoldersCommandProvider
    extends $AsyncNotifierProvider<ReorderFoldersCommand, void> {
  ReorderFoldersCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reorderFoldersCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reorderFoldersCommandHash();

  @$internal
  @override
  ReorderFoldersCommand create() => ReorderFoldersCommand();
}

String _$reorderFoldersCommandHash() =>
    r'e9172d85a90bc6ddaff2c460129030be63d3e988';

abstract class _$ReorderFoldersCommand extends $AsyncNotifier<void> {
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
