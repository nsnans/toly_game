
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../utils/size_utils.dart';
import 'app/sweeper_app.dart';

main() {
  runApp(OKToast(child: const SweeperApp()));
  SizeUtils.setSize(size: const Size( 800,600));
}