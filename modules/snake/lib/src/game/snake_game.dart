import 'dart:async';
import 'dart:ui';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:snake/src/game/heroes/hud/hud.dart';
import 'package:snake/src/model/configable.dart';
import 'package:snake/src/logic/game_render.dart';
import 'package:tolyui/tolyui.dart';
import 'dart:math';
import '../logic/game_state_mixin.dart';
import '../model/speed.dart';
import '../model/foods.dart';
import '../model/game_status.dart';
import 'heroes/ground.dart';
import 'heroes/toolbar/tool_bar.dart';
import '../logic/game_ctrl_mixin.dart';

class SnakeGame extends FlameGame
    with KeyboardEvents, DirectionCtrlMixin, Configable, GameStateMixin, WorldRender
    implements GameOperation {
  @override
  void onDirectionChange(Direction direction) {
    tickRender(direction);
  }

  Ground ground = Ground();

  @override
  FutureOr<void> onLoad() {
    add(Hud());
    add(ground);
    add(ToolBar());
    reset();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (status != GameStatus.playing) {
      paused = true;
    }
    tickFrameUpdate(dt);
    tickRender(lastDirection);
  }

  @override
  void onSnakeChange() {
    ground.updateSnake();
  }

  @override
  void onFoodChange(FoodNode food) {
    ground.updateFoods();
  }

  @override
  void onSpaceCtrl() {
    if (status == GameStatus.playing) {
      status = GameStatus.paused;
      Future.delayed(const Duration(milliseconds: 0)).then((_) => paused = false);
    } else {
      if (status == GameStatus.died) {
        lastDirection = Direction.up;

        reset();
      }
      status = GameStatus.playing;
      paused = false;
    }
  }

  @override
  void onDied() {
    status = GameStatus.died;
    $message.warning(message: '游戏结束!', offset: Offset(0, 36));
  }

  @override
  void onEatFood(FoodNode food) {
    addScore(food.score);
  }

  @override
  void onSpeedUp() {
    int level = speed.level;
    setSpeed(level + 1);
  }
}
