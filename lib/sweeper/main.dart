
import 'package:flutter/material.dart';

import '../utils/size_utils.dart';
import 'app/sweeper_app.dart';

main() {
  runApp(const SweeperApp());
  SizeUtils.setSize(size: const Size( 360 * 2400 / 1080 + 30 - 18,360));
}