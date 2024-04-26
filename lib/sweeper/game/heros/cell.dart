import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:toly_game/sweeper/game/sweeper_game.dart';

import '../sweeper_world.dart';

enum CellType{
  hide,
  open,
  boom
}

class CellData{
  int value = 0;
}

double get cellSize => 18;
(int,int) get gridSize => (30,16);

class CellManager extends PositionComponent with HasGameRef<SweeperGame> {



  @override
  FutureOr<void> onLoad() {
    addAll(_createBricks());
    return super.onLoad();
  }

  List<Cell> _createBricks() {
    List<Cell> result = [];
    for (int i = 0; i < gridSize.$2; i++) {
      // List<int> rows = tiles[i];
      for (int j = 0; j < gridSize.$1; j++) {
        // if (rows[j] == 1) {
        //   int index = game.random.nextInt(srcPool.length);
        //   String src = srcPool[index];
          Cell cell = Cell((j,i));
          cell.x = cellSize * j;
          cell.y = cellSize * i;
          result.add(cell);
        // }
      }
    }
    return result;
  }
}

class Cell extends SpriteComponent with HasGameRef<SweeperGame>
// TapCallbacks,
{
  (int,int) pos;
  Cell(this.pos);

  @override
  FutureOr<void> onLoad() {
    size = Vector2(cellSize, cellSize);
    sprite = game.loader['hide.png'];
    return super.onLoad();
  }

  void pressed(){
    sprite = game.loader['pressed.png'];
  }

  void reset(){
    sprite = game.loader['hide.png'];
  }

}
