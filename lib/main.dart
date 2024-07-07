import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:life_game/life_game.dart';
import 'package:toly_game/utils/platform_adapter/views/window_buttons.dart';
import 'package:window_manager/window_manager.dart';

import '../utils/size_utils.dart';

main() {
  runApp(LifeGameApp());
  SizeUtils.setSize(size: const Size(800, 460));
}

class LifeGameApp extends StatelessWidget {
  const LifeGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: '宋体',
        scaffoldBackgroundColor: Color(0xff3c3f41),
        // textTheme:
      ),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                DragToMoveArea(
                  child: Container(
                    alignment: Alignment.center,
                    height: 30,
                    color: Color(0xff3c3f41),
                    child: Text(
                      '生命游戏 | Game of Life',
                      style: TextStyle( fontSize: 12, height: 1),
                    ),
                  ),
                ),
                Positioned(
                    right: 0,
                    child: const WindowButtons())
              ],
            ),
            Expanded(child: LifeGameView())
          ],
        ),
      ),
    );
  }
}
