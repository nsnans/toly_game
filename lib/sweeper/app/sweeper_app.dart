import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:toly_game/bricks/04/ui_components/app_top_bar.dart';

import '../../utils/platform_adapter/window/windows_adapter.dart';
import '../game/sweeper_game.dart';

class SweeperApp extends StatelessWidget {
  const SweeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PlatformAdapterApp(),
    );
  }
}


class PlatformAdapterApp extends StatelessWidget {

  const PlatformAdapterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildHomeByPlatform();
  }

  Widget _buildHomeByPlatform() {
    Widget home =  GameWidget(game: SweeperGame());
    if (!kIsWeb&&kIsDesk) {
      home = Column(
        children: [
          const AppTopBar(),
          Expanded(child: home),
        ],
      );
    }
    return home;
  }
}