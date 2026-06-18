// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SendMessageCommand)
final sendMessageCommandProvider = SendMessageCommandProvider._();

final class SendMessageCommandProvider
    extends $AsyncNotifierProvider<SendMessageCommand, void> {
  SendMessageCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendMessageCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendMessageCommandHash();

  @$internal
  @override
  SendMessageCommand create() => SendMessageCommand();
}

String _$sendMessageCommandHash() =>
    r'bc0812c0dfcc64e0cf620f566658b714b6d5c415';

abstract class _$SendMessageCommand extends $AsyncNotifier<void> {
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
