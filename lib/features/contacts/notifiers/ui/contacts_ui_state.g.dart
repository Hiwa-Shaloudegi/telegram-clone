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
