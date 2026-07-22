// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_chats_to_folder_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddChatsToFolderCommand)
final addChatsToFolderCommandProvider = AddChatsToFolderCommandProvider._();

final class AddChatsToFolderCommandProvider
    extends $AsyncNotifierProvider<AddChatsToFolderCommand, void> {
  AddChatsToFolderCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addChatsToFolderCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addChatsToFolderCommandHash();

  @$internal
  @override
  AddChatsToFolderCommand create() => AddChatsToFolderCommand();
}

String _$addChatsToFolderCommandHash() =>
    r'b7a8e8306fa36c67543fb17e6cc49de600c60412';

abstract class _$AddChatsToFolderCommand extends $AsyncNotifier<void> {
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
