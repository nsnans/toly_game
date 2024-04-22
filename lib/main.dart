import 'package:flutter/material.dart';

import 'bricks/07/app.dart';
import 'utils/size_utils.dart';

main() {
  runApp(const TolyGameApp());
  SizeUtils.setSize(size: const Size(360, 360 * 2400 / 1080 + 30 - 18));

  SizeUtils.fullScreenMobile();
}


