import 'package:share_plus/share_plus.dart';

Future<void> shareInvite({required String message}) async {
  await SharePlus.instance.share(ShareParams(text: message));
}
