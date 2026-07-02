// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_first_dm_message_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SendFirstDmMessageCommand)
final sendFirstDmMessageCommandProvider = SendFirstDmMessageCommandProvider._();

final class SendFirstDmMessageCommandProvider
    extends $AsyncNotifierProvider<SendFirstDmMessageCommand, void> {
  SendFirstDmMessageCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendFirstDmMessageCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendFirstDmMessageCommandHash();

  @$internal
  @override
  SendFirstDmMessageCommand create() => SendFirstDmMessageCommand();
}

String _$sendFirstDmMessageCommandHash() =>
    r'81c14bd36e2f6dd7b9b9f42acc41e23c9803f788';

abstract class _$SendFirstDmMessageCommand extends $AsyncNotifier<void> {
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
