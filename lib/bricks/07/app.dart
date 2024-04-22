import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:toly_game/bricks/07/overlays/loading_page/assets_loading_page.dart';

import '../../utils/platform_adapter/window/windows_adapter.dart';
import 'bricks_game.dart';
import 'config/res_manager.dart';
import 'overlays/home_page/home_page.dart';
import 'overlays/lever_page/level_page.dart';
import 'overlays/menus/exit_menu.dart';
import 'overlays/menus/game_over_menu.dart';
import 'overlays/menus/game_win_menu.dart';
import 'overlays/menus/goods_info_menu.dart';
import 'overlays/menus/pause_menu.dart';
import 'overlays/package_page/package_page.dart';
import 'overlays/settings/settings_page.dart';
import 'overlays/shop_page/shop_page.dart';

import 'ui_components/app_top_bar.dart';

class TolyGameApp extends StatelessWidget {
  const TolyGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child : MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: '宋体',
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle:
                  TextStyle(color: Colors.white, fontSize: 18, fontFamily: "宋体"),
            )),
        home: const AssetsLoadingPage(),
      ),
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
    Widget home =  BricksGameApp();
    if (kIsDesk) {
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


class BricksGameApp extends StatelessWidget{

  const BricksGameApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GameWidget<BricksGame>.controlled(
      gameFactory: BricksGame.new,
      overlayBuilderMap: {
        'HomePage': (_, game) => HomePage(game: game),
        'Settings': (_, game) => SettingsPage(game: game),
        'ShopPage': (_, game) => ShopPage(game: game),
        'LevelPage': (_, game) => LevelPage(game: game),
        'PauseMenu': (_, game) => PauseMenu(game: game),
        'ExitMenu': (_, game) => ExitMenu(game: game),
        'GameOverMenu': (_, game) => GameOverMenu(game: game),
        'GoodsInfoMenu': (_, game) => GoodsInfoMenu(game: game,),
        'GameSuccessMenu': (_, game) => GameSuccessMenu(game: game),
        'PackagePage': (_, game) => PackagePage(game: game),
      },
      initialActiveOverlays: const ['HomePage'],
    );
  }
}
