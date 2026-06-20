// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_messages_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeleteMessagesCommand)
final deleteMessagesCommandProvider = DeleteMessagesCommandProvider._();

final class DeleteMessagesCommandProvider
    extends $AsyncNotifierProvider<DeleteMessagesCommand, void> {
  DeleteMessagesCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteMessagesCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteMessagesCommandHash();

  @$internal
  @override
  DeleteMessagesCommand create() => DeleteMessagesCommand();
}

String _$deleteMessagesCommandHash() =>
    r'1c08154b457498d0f30b7b63abf2cbfdfdde6ed2';

abstract class _$DeleteMessagesCommand extends $AsyncNotifier<void> {
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
