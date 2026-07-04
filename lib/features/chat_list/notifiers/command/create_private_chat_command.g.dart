// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_private_chat_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreatePrivateChatCommand)
final createPrivateChatCommandProvider = CreatePrivateChatCommandProvider._();

final class CreatePrivateChatCommandProvider
    extends $AsyncNotifierProvider<CreatePrivateChatCommand, void> {
  CreatePrivateChatCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createPrivateChatCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createPrivateChatCommandHash();

  @$internal
  @override
  CreatePrivateChatCommand create() => CreatePrivateChatCommand();
}

String _$createPrivateChatCommandHash() =>
    r'ec385c3a537e8bc60246b6583c18ea29590cfe43';

abstract class _$CreatePrivateChatCommand extends $AsyncNotifier<void> {
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
