import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:toly_game/sweeper/game/heros/cell.dart';

class SweeperHud extends PositionComponent{

  @override
  void onGameResize(Vector2 size) {
    x = (size.x-width)/2;
    super.onGameResize(size);
  }

  @override
  FutureOr<void> onLoad() {
    size = Vector2(gridSize.$1*cellSize, gridSize.$2*cellSize)+Vector2(12,46+12);
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Offset.zero&Size(width, height), Paint()..color=Color(0xffc0c0c0));
    // canvas.drawRect(Rect.fromLTWH(0,46, gridSize.$1*cellSize+12, gridSize.$2*cellSize+12), Paint()..color=Color(0xff808080));
    super.render(canvas);
  }
}