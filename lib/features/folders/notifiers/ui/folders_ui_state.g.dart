// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folders_ui_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `null` means the built-in "All" tab is selected.

@ProviderFor(SelectedFolderId)
final selectedFolderIdProvider = SelectedFolderIdProvider._();

/// `null` means the built-in "All" tab is selected.
final class SelectedFolderIdProvider
    extends $NotifierProvider<SelectedFolderId, String?> {
  /// `null` means the built-in "All" tab is selected.
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

String _$selectedFolderIdHash() => r'26fa55df25cbba6062463a9d7bb7e0e491fc1ad6';

/// `null` means the built-in "All" tab is selected.

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

@ProviderFor(EditFolder_chatIds)
final editFolder_chatIdsProvider = EditFolder_chatIdsProvider._();

final class EditFolder_chatIdsProvider
    extends $NotifierProvider<EditFolder_chatIds, Set<String>> {
  EditFolder_chatIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editFolder_chatIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editFolder_chatIdsHash();

  @$internal
  @override
  EditFolder_chatIds create() => EditFolder_chatIds();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$editFolder_chatIdsHash() =>
    r'f3c60a771464414a5eee408bd07bd33c73b38f06';

abstract class _$EditFolder_chatIds extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(EditFolder_saving)
final editFolder_savingProvider = EditFolder_savingProvider._();

final class EditFolder_savingProvider
    extends $NotifierProvider<EditFolder_saving, bool> {
  EditFolder_savingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editFolder_savingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editFolder_savingHash();

  @$internal
  @override
  EditFolder_saving create() => EditFolder_saving();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$editFolder_savingHash() => r'a25cf4eaeab5608e5520f5db48135bc30bd642e3';

abstract class _$EditFolder_saving extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(EditFolder_name)
final editFolder_nameProvider = EditFolder_nameProvider._();

final class EditFolder_nameProvider
    extends $NotifierProvider<EditFolder_name, String> {
  EditFolder_nameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editFolder_nameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editFolder_nameHash();

  @$internal
  @override
  EditFolder_name create() => EditFolder_name();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$editFolder_nameHash() => r'cf901de6f9c07cc18cbf3c260e0b827e55a89bf6';

abstract class _$EditFolder_name extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(AddChats_selected)
final addChats_selectedProvider = AddChats_selectedProvider._();

final class AddChats_selectedProvider
    extends $NotifierProvider<AddChats_selected, Set<String>> {
  AddChats_selectedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addChats_selectedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addChats_selectedHash();

  @$internal
  @override
  AddChats_selected create() => AddChats_selected();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$addChats_selectedHash() => r'ffd6767fb645219c5cb0021a924e07e7538f4f58';

abstract class _$AddChats_selected extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(AddChats_query)
final addChats_queryProvider = AddChats_queryProvider._();

final class AddChats_queryProvider
    extends $NotifierProvider<AddChats_query, String> {
  AddChats_queryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addChats_queryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addChats_queryHash();

  @$internal
  @override
  AddChats_query create() => AddChats_query();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$addChats_queryHash() => r'c588e170519ecd72a1000f356e1e2214b6e7464e';

abstract class _$AddChats_query extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(AddChats_saving)
final addChats_savingProvider = AddChats_savingProvider._();

final class AddChats_savingProvider
    extends $NotifierProvider<AddChats_saving, bool> {
  AddChats_savingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addChats_savingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addChats_savingHash();

  @$internal
  @override
  AddChats_saving create() => AddChats_saving();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$addChats_savingHash() => r'e770b3200ad09ea6ef70c0ed3526156e029d7c43';

abstract class _$AddChats_saving extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ReorderFolders_isActive)
final reorderFolders_isActiveProvider = ReorderFolders_isActiveProvider._();

final class ReorderFolders_isActiveProvider
    extends $NotifierProvider<ReorderFolders_isActive, bool> {
  ReorderFolders_isActiveProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reorderFolders_isActiveProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reorderFolders_isActiveHash();

  @$internal
  @override
  ReorderFolders_isActive create() => ReorderFolders_isActive();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$reorderFolders_isActiveHash() =>
    r'4767e1bc071f9f30e009e72677c39ae31b0ddb1b';

abstract class _$ReorderFolders_isActive extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ReorderFolders_local)
final reorderFolders_localProvider = ReorderFolders_localProvider._();

final class ReorderFolders_localProvider
    extends $NotifierProvider<ReorderFolders_local, List<ChatFolderModel>?> {
  ReorderFolders_localProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reorderFolders_localProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reorderFolders_localHash();

  @$internal
  @override
  ReorderFolders_local create() => ReorderFolders_local();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ChatFolderModel>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ChatFolderModel>?>(value),
    );
  }
}

String _$reorderFolders_localHash() =>
    r'a0481f6862c0bab45e3c232a9dc1d511d82d2895';

abstract class _$ReorderFolders_local
    extends $Notifier<List<ChatFolderModel>?> {
  List<ChatFolderModel>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<List<ChatFolderModel>?, List<ChatFolderModel>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ChatFolderModel>?, List<ChatFolderModel>?>,
              List<ChatFolderModel>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ReorderFolders_saving)
final reorderFolders_savingProvider = ReorderFolders_savingProvider._();

final class ReorderFolders_savingProvider
    extends $NotifierProvider<ReorderFolders_saving, bool> {
  ReorderFolders_savingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reorderFolders_savingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reorderFolders_savingHash();

  @$internal
  @override
  ReorderFolders_saving create() => ReorderFolders_saving();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$reorderFolders_savingHash() =>
    r'f5f87bb356e2c7743bd7e8522f23029918aff22f';

abstract class _$ReorderFolders_saving extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
