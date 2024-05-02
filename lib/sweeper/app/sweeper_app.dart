import 'package:flame/game.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tolyui/basic/basic.dart';

import '../../utils/platform_adapter/window/windows_adapter.dart';
import '../game/sweeper_game.dart';
import 'actions/navigation.dart';
import 'app_top_bar.dart';
import 'swipper_app_bar.dart';

class SweeperApp extends StatelessWidget {
  const SweeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle:   const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        )
        )
      ),
      home: PlatformAdapterApp(),
    );
  }
}

class PlatformAdapterApp extends StatefulWidget {
  const PlatformAdapterApp({super.key});

  @override
  State<PlatformAdapterApp> createState() => _PlatformAdapterAppState();
}

class _PlatformAdapterAppState extends State<PlatformAdapterApp> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return _buildHomeByPlatform(width);
  }

  final SweeperGame game= SweeperGame();

  Widget _buildHomeByPlatform(double width) {
    Widget home = Scaffold(
        appBar: const SweeperAppBar(),
        body: Stack(
          children: [
            GameWidget(game: game),
             Positioned(
              bottom: 4 ,
              width: width,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TolyLink(
                      text: "张风捷特烈·出品",
                      hoverColor: Colors.blue,
                      style: TextStyle(fontSize: 12,color: Colors.grey),
                      href: 'https://juejin.cn/column/7101817687877091358',
                      onTap: jumpUrl,
                    ),
                    TolyLink(
                      onTap: jumpUrl,
                      text: "Made by Flutter&Flame",
                      hoverColor: Colors.blue,
                      href: 'https://github.com/flutter/flutter',
                      style: TextStyle(fontSize: 12,color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
    if (!kIsWeb && kIsDesk) {
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
