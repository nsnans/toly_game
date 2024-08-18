import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:snake/snake.dart';

import 'game_ctrl_mixin.dart';

class GameGestureDetector extends StatelessWidget {
  final SnakeGame game;
  const GameGestureDetector({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          game.onSpaceCtrl();
        },
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta! < 0) {
            game.tickDirectionChange(Direction.up);
          } else if (details.primaryDelta! > 0) {
            game.tickDirectionChange(Direction.down);
          }
        },
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 0) {
            game.tickDirectionChange(Direction.right);
          } else if (details.primaryDelta! < 0) {
            game.tickDirectionChange(Direction.left);
          }
        },
        child: GameWidget(game: game));
  }
}

