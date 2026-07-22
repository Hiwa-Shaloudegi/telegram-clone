// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_folders_query.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WatchFoldersQuery)
final watchFoldersQueryProvider = WatchFoldersQueryProvider._();

final class WatchFoldersQueryProvider
    extends $StreamNotifierProvider<WatchFoldersQuery, List<ChatFolderModel>> {
  WatchFoldersQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchFoldersQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchFoldersQueryHash();

  @$internal
  @override
  WatchFoldersQuery create() => WatchFoldersQuery();
}

String _$watchFoldersQueryHash() => r'3b5bba554122b45c4914450ecd173a033cbc6d89';

abstract class _$WatchFoldersQuery
    extends $StreamNotifier<List<ChatFolderModel>> {
  Stream<List<ChatFolderModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<ChatFolderModel>>, List<ChatFolderModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ChatFolderModel>>,
                List<ChatFolderModel>
              >,
              AsyncValue<List<ChatFolderModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
