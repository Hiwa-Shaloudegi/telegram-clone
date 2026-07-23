/// Extra payload for the user profile route.
///
/// [chatId] is optional — when present, the page can offer a "Send message"
/// shortcut back into the chat. [displayName] / [avatarUrl] are passed so the
/// page can render the header immediately before the profile fetch resolves
/// (Telegram shows the cached name/photo instantly).
class UserProfileExtra {
  final String userId;
  final String? chatId;
  final String? displayName;
  final String? avatarUrl;

  const UserProfileExtra({
    required this.userId,
    this.chatId,
    this.displayName,
    this.avatarUrl,
  });
}
