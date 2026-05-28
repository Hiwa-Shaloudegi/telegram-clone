// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_contacts_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeleteContactsCommand)
final deleteContactsCommandProvider = DeleteContactsCommandProvider._();

final class DeleteContactsCommandProvider
    extends $AsyncNotifierProvider<DeleteContactsCommand, void> {
  DeleteContactsCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteContactsCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteContactsCommandHash();

  @$internal
  @override
  DeleteContactsCommand create() => DeleteContactsCommand();
}

String _$deleteContactsCommandHash() =>
    r'21990c3f633d18d60159999a69a42e6564075ae0';

abstract class _$DeleteContactsCommand extends $AsyncNotifier<void> {
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
