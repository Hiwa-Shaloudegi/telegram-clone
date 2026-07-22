// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folders_ui_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedFolderId)
final selectedFolderIdProvider = SelectedFolderIdProvider._();

final class SelectedFolderIdProvider
    extends $NotifierProvider<SelectedFolderId, String?> {
  SelectedFolderIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedFolderIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedFolderIdHash();

  @$internal
  @override
  SelectedFolderId create() => SelectedFolderId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedFolderIdHash() => r'folder_ui_gen_hash_001';

abstract class _$SelectedFolderId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
