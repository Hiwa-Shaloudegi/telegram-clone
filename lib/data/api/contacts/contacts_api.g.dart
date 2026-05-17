// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(contactsApi)
final contactsApiProvider = ContactsApiProvider._();

final class ContactsApiProvider
    extends $FunctionalProvider<ContactsApi, ContactsApi, ContactsApi>
    with $Provider<ContactsApi> {
  ContactsApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsApiHash();

  @$internal
  @override
  $ProviderElement<ContactsApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ContactsApi create(Ref ref) {
    return contactsApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContactsApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContactsApi>(value),
    );
  }
}

String _$contactsApiHash() => r'67cfb7d7850bd77056d8eabcddf0db5a1ca8ea15';
