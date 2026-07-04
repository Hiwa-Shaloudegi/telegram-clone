import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class EagerInitialization extends ConsumerWidget {
  const EagerInitialization({
    super.key,
    required this.providers,
    required this.child,
  });

  final List<ProviderListenable<Object?>> providers;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    for (final provider in providers) {
      ref.watch(provider);
    }

    return child;
  }
}
