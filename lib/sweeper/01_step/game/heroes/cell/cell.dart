import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';

import '../../sweeper_game.dart';

enum CellType {
  close('images/sweeper/closed.svg'),
  mine('images/sweeper/mine.svg'),
  pressed('images/sweeper/pressed.svg'),
  flag('images/sweeper/flag.svg');

  final String src;

  const CellType(this.src);
}

class CellData {
  int value = 0;
}



class Cell extends SvgComponent with HasGameRef<SweeperGame> {
  final (int, int) pos;

  Cell(this.pos);

  @override
  FutureOr<void> onLoad() {
    double cellSize = game.sizeRes.cellSize;
    size = Vector2(cellSize, cellSize);
    svg = game.loader.findSvg('closed.svg');
    return super.onLoad();
  }

  void pressed() {
    svg = game.loader.findSvg('pressed.svg');
  }

  void reset() {
    svg = game.loader.findSvg('closed.svg');
  }
}
