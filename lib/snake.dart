import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:snake/snake.dart';
import 'package:tolyui/tolyui.dart';

import 'utils/platform_adapter/views/window_buttons.dart';
import 'utils/platform_adapter/window/windows_adapter.dart';

class SnakeGameApp extends StatelessWidget {
  SnakeGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyMessage(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: '宋体',
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle:
              TextStyle(color: Colors.white, fontSize: 18, fontFamily: "宋体"),
            )),
        home: _buildHomeByPlatform(),
      ),
    );
  }
  final SnakeGame snakeGame =  SnakeGame();
  Widget _buildHomeByPlatform() {
    Widget home =  GameGestureDetector(game:  snakeGame);
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

class AppTopBar extends StatelessWidget {
  const AppTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const DragToMoveAreaNoDouble(
      child: Material(
        color: Color(0xffebebeb),
        child: SizedBox(
          height: 30,
          child: NavigationToolbar(
            middle: Text(
              "Snake",
              style: TextStyle(fontSize: 12),
            ),
            trailing: WindowButtons(),
          ),
        ),
      ),
    );
  }
}
