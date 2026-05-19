// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_contact_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddContactCommand)
final addContactCommandProvider = AddContactCommandProvider._();

final class AddContactCommandProvider
    extends $AsyncNotifierProvider<AddContactCommand, bool> {
  AddContactCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addContactCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addContactCommandHash();

  @$internal
  @override
  AddContactCommand create() => AddContactCommand();
}

String _$addContactCommandHash() => r'd59d6215e6c374cc3d96aa5e625ea28da1057cc4';

abstract class _$AddContactCommand extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
