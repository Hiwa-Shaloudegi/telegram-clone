import 'package:url_launcher/url_launcher.dart';

Future<void> shareInvite({required String message}) async {
  final mailtoUri = Uri(
    scheme: 'mailto',
    queryParameters: {'subject': 'Join me on Telegram!', 'body': message},
  );
  if (await canLaunchUrl(mailtoUri)) {
    await launchUrl(mailtoUri);
  }
}
