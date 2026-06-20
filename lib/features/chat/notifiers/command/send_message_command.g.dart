// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SendMessageCommand)
final sendMessageCommandProvider = SendMessageCommandFamily._();

final class SendMessageCommandProvider
    extends $AsyncNotifierProvider<SendMessageCommand, void> {
  SendMessageCommandProvider._({
    required SendMessageCommandFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sendMessageCommandProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sendMessageCommandHash();

  @override
  String toString() {
    return r'sendMessageCommandProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SendMessageCommand create() => SendMessageCommand();

  @override
  bool operator ==(Object other) {
    return other is SendMessageCommandProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sendMessageCommandHash() =>
    r'ad924019c9628b43f16824b79037fad529d32493';

final class SendMessageCommandFamily extends $Family
    with
        $ClassFamilyOverride<
          SendMessageCommand,
          AsyncValue<void>,
          void,
          FutureOr<void>,
          String
        > {
  SendMessageCommandFamily._()
    : super(
        retry: null,
        name: r'sendMessageCommandProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SendMessageCommandProvider call(String messageTempId) =>
      SendMessageCommandProvider._(argument: messageTempId, from: this);

  @override
  String toString() => r'sendMessageCommandProvider';
}

abstract class _$SendMessageCommand extends $AsyncNotifier<void> {
  late final _$args = ref.$arg as String;
  String get messageTempId => _$args;

  FutureOr<void> build(String messageTempId);
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
    element.handleCreate(ref, () => build(_$args));
  }
}
