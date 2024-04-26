import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../sweeper_game.dart';
import 'cell.dart';


class SweeperPlayground extends PositionComponent with DragCallbacks, HasGameRef<SweeperGame>{

  @override
  void onGameResize(Vector2 size) {
    x = (size.x-width)/2;
    super.onGameResize(size);
  }

  @override
  FutureOr<void> onLoad() {
    size = Vector2(gridSize.$1*cellSize, gridSize.$2*cellSize);
    // anchor=Anchor.centerLeft;
    // add(CircleComponent());
    add(CellManager());

    return super.onLoad();
  }
  final Paint _gridPaint = Paint();

  @override
  void render(Canvas canvas) {
    // print("===========$width=======$height=======");
    // canvas.drawRect(Offset.zero&Size(width, height), Paint());
    // drawGrid(canvas,Size(width, height));
    super.render(canvas);
  }
  void drawGrid(Canvas canvas, Size size) {
    Paint girdPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Color(0xff838383);
    Path path = Path();
    double stepH = size.height / gridSize.$2;
    for (int i = 1; i < gridSize.$2; i++) {
      path.moveTo(0, stepH * i);
      path.relativeLineTo(size.width, 0);
    }
    double stepW = size.width / gridSize.$1;
    for (int i = 1; i < gridSize.$1; i++) {
      path.moveTo(stepW * i, 0);
      path.relativeLineTo(0, size.height);
    }
    canvas.drawPath(path, girdPaint);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {

    double stepH = height / gridSize.$2;
    double stepW = width / gridSize.$1;
    int x = event.localStartPosition.x ~/ stepW;
    int y = event.localStartPosition.y ~/ stepH;
    print("======($x,$y)==============");
    game.world.pressed((x,y));
    super.onDragUpdate(event);
  }

}