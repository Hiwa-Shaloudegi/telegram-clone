// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_ui_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ContactsUi_sortBy)
final contactsUi_sortByProvider = ContactsUi_sortByProvider._();

final class ContactsUi_sortByProvider
    extends $NotifierProvider<ContactsUi_sortBy, ContactsSortBy> {
  ContactsUi_sortByProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsUi_sortByProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsUi_sortByHash();

  @$internal
  @override
  ContactsUi_sortBy create() => ContactsUi_sortBy();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContactsSortBy value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContactsSortBy>(value),
    );
  }
}

String _$contactsUi_sortByHash() => r'73d3e980b5681fbd7b9c9ccfb355b1fda6efc0af';

abstract class _$ContactsUi_sortBy extends $Notifier<ContactsSortBy> {
  ContactsSortBy build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ContactsSortBy, ContactsSortBy>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ContactsSortBy, ContactsSortBy>,
              ContactsSortBy,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ContactsUi_selectedContacts)
final contactsUi_selectedContactsProvider =
    ContactsUi_selectedContactsProvider._();

final class ContactsUi_selectedContactsProvider
    extends $NotifierProvider<ContactsUi_selectedContacts, HashSet<String>> {
  ContactsUi_selectedContactsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsUi_selectedContactsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsUi_selectedContactsHash();

  @$internal
  @override
  ContactsUi_selectedContacts create() => ContactsUi_selectedContacts();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HashSet<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HashSet<String>>(value),
    );
  }
}

String _$contactsUi_selectedContactsHash() =>
    r'283904a0f7bf1e799092c9558c1594ec10c1d6e6';

abstract class _$ContactsUi_selectedContacts
    extends $Notifier<HashSet<String>> {
  HashSet<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<HashSet<String>, HashSet<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HashSet<String>, HashSet<String>>,
              HashSet<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(isSelectionMode)
final isSelectionModeProvider = IsSelectionModeProvider._();

final class IsSelectionModeProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  IsSelectionModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isSelectionModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isSelectionModeHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isSelectionMode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isSelectionModeHash() => r'b1b11a21e3f87fb6303c21ae5c6a55b462cc8b21';
