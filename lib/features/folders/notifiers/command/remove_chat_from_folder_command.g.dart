// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_chat_from_folder_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RemoveChatFromFolderCommand)
final removeChatFromFolderCommandProvider =
    RemoveChatFromFolderCommandProvider._();

final class RemoveChatFromFolderCommandProvider
    extends $AsyncNotifierProvider<RemoveChatFromFolderCommand, void> {
  RemoveChatFromFolderCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'removeChatFromFolderCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$removeChatFromFolderCommandHash();

  @$internal
  @override
  RemoveChatFromFolderCommand create() => RemoveChatFromFolderCommand();
}

String _$removeChatFromFolderCommandHash() =>
    r'f3659e489284ebf5409de6c72d48e1dea9437828';

abstract class _$RemoveChatFromFolderCommand extends $AsyncNotifier<void> {
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
