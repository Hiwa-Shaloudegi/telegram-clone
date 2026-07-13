// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_messages_read_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MarkMessagesReadCommand)
final markMessagesReadCommandProvider = MarkMessagesReadCommandFamily._();

final class MarkMessagesReadCommandProvider
    extends $NotifierProvider<MarkMessagesReadCommand, void> {
  MarkMessagesReadCommandProvider._({
    required MarkMessagesReadCommandFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'markMessagesReadCommandProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$markMessagesReadCommandHash();

  @override
  String toString() {
    return r'markMessagesReadCommandProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MarkMessagesReadCommand create() => MarkMessagesReadCommand();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MarkMessagesReadCommandProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$markMessagesReadCommandHash() =>
    r'132674dc01d5c97dfeff476f16e52d93f953746b';

final class MarkMessagesReadCommandFamily extends $Family
    with
        $ClassFamilyOverride<
          MarkMessagesReadCommand,
          void,
          void,
          void,
          String
        > {
  MarkMessagesReadCommandFamily._()
    : super(
        retry: null,
        name: r'markMessagesReadCommandProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  MarkMessagesReadCommandProvider call(String chatId) =>
      MarkMessagesReadCommandProvider._(argument: chatId, from: this);

  @override
  String toString() => r'markMessagesReadCommandProvider';
}

abstract class _$MarkMessagesReadCommand extends $Notifier<void> {
  late final _$args = ref.$arg as String;
  String get chatId => _$args;

  void build(String chatId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
