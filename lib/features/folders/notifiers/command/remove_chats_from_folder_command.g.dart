// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_chats_from_folder_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RemoveChatsFromFolderCommand)
final removeChatsFromFolderCommandProvider =
    RemoveChatsFromFolderCommandProvider._();

final class RemoveChatsFromFolderCommandProvider
    extends $AsyncNotifierProvider<RemoveChatsFromFolderCommand, void> {
  RemoveChatsFromFolderCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'removeChatsFromFolderCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$removeChatsFromFolderCommandHash();

  @$internal
  @override
  RemoveChatsFromFolderCommand create() => RemoveChatsFromFolderCommand();
}

String _$removeChatsFromFolderCommandHash() =>
    r'9511e5a9609043a10f0da26e97ba099889394352';

abstract class _$RemoveChatsFromFolderCommand extends $AsyncNotifier<void> {
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
