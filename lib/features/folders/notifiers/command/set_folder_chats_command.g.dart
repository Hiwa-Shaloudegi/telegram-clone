// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_folder_chats_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SetFolderChatsCommand)
final setFolderChatsCommandProvider = SetFolderChatsCommandProvider._();

final class SetFolderChatsCommandProvider
    extends $AsyncNotifierProvider<SetFolderChatsCommand, void> {
  SetFolderChatsCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setFolderChatsCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setFolderChatsCommandHash();

  @$internal
  @override
  SetFolderChatsCommand create() => SetFolderChatsCommand();
}

String _$setFolderChatsCommandHash() =>
    r'd890716607c56443117770ad9ca9253e46482540';

abstract class _$SetFolderChatsCommand extends $AsyncNotifier<void> {
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
