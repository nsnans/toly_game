import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';

import 'snake.dart';

class Foods extends PositionComponent {
  final Iterable<Point<int>> points;

  Foods(this.points);

  @override
  FutureOr<void> onLoad() {
    setFrame();
    return super.onLoad();
  }

  void setFrame() {
    removeWhere((e) => true);
    for (Point<int> point in points) {
      add(Cell(point, type: CellType.food, side: 24));
    }
  }
}
