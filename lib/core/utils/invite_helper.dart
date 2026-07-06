import 'invite_helper_native.dart'
    if (dart.library.html) 'invite_helper_web.dart' as platform;

class InviteHelper {
  const InviteHelper._();

  static const _inviteMessage =
      'Hey! I\'m using Telegram Messenger. '
      'Join me there! Download it for free at https://telegram.org/dl';

  static Future<void> inviteContact({String? contactName}) async {
    final message = contactName != null
        ? 'Hey $contactName! $_inviteMessage'
        : _inviteMessage;

    await platform.shareInvite(message: message);
  }
}
