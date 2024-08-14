import 'dart:async';
import 'dart:ui';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:snake/src/logic/configable.dart';
import 'package:snake/src/logic/snake_render.dart';
import 'package:tolyui/tolyui.dart';
import 'dart:math';
import 'heroes/ground.dart';
import 'mixin/direction_mixin.dart';

class SnakeGame extends FlameGame
    with KeyboardEvents, DirectionCtrlMixin, Configable, WorldRender
    implements DirectionChange {

  @override
  void onDirectionChange(Direction direction) {
    tickRender(direction);
  }

  Ground ground = Ground();
  @override
  FutureOr<void> onLoad() {
    add(ground);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if(status!=GameStatus.playing){
      paused = true;
    }
    tickRender(lastDirection);
  }

  @override
  void onSnakeChange() {
    ground.updateSnake();
  }

  @override
  void onFoodChange(Point<int> food) {
    ground.updateFoods();
  }

  @override
  void onStart() {
    if(status== GameStatus.playing){
      status = GameStatus.paused;
      paused = true;
    }else{
      status = GameStatus.playing;
      paused = false;
    }
  }

  @override
  void onDied() {
    status = GameStatus.died;
    $message.warning(message: '游戏结束!',offset: Offset(0, 36));
  }
}
