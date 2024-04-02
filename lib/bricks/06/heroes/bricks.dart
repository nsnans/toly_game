import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../bricks_game.dart';


class BrickManager extends PositionComponent with HasGameRef<BricksGame> {
  @override
  FutureOr<void> onLoad() {
    priority=10;
    addAll(_createBricks());
    width = 64.0 * 9;
    return super.onLoad();
  }

  List<Brick> _createBricks() {
    List<List<int>> tiles = game.level.tiles;
    List<Brick> bricks = [];
    for (int i = 0; i < tiles.length; i++) {
      List<int> rows = tiles[i];
      for (int j = 0; j < rows.length; j++) {
        if (rows[j] == 1) {
          Brick brick = Brick(j + tiles.length * i);
          brick.x = 64.0 * j;
          brick.y = 32.0 * i;
          bricks.add(brick);
        }
      }
    }
    return bricks;
  }
}

// class BrickAndProp extends PositionComponent with HasGameRef<BricksGame> {
//   @override
//   FutureOr<void> onLoad() {
//     Brick brick = Brick();
//     add(brick);
//     PropComponent prop = PropComponent(Prop.addBall);
//     prop
//       ..anchor = Anchor.center
//       ..x = brick.x + brick.width / 2
//       ..y = brick.y + brick.height / 2;
//     add(prop);
//     add(RectangleHitbox());
//     return super.onLoad();
//   }
//
//
// }

class Brick extends SpriteComponent with HasGameRef<BricksGame> {

  final int id;

  Brick(this.id);

  @override
  FutureOr<void> onLoad() {
    // priority = 10;
    sprite = game.loader['Colored_Blue-64x32.png'];
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void onRemove() {
    super.onRemove();
    game.world.checkSuccess();
  }
}
