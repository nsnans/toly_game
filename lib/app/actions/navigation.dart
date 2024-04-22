import 'package:toly_game/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart';

void jumpUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    Toast.error('无法跳转链接');
  }
}