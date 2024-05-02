import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../heroes/cell/cell.dart';
import '../sweeper_game.dart';

mixin GameCellLogic on DragCallbacks, TapCallbacks, HasGameRef<SweeperGame> {
  /// 被按压的单元格
  final List<Cell> _pressedCells = [];

  @override
  void onTapDown(TapDownEvent event) {
    pressed(event.localPosition);
    super.onTapDown(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    pressed(event.localStartPosition);
    super.onDragUpdate(event);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    unpressed();
    super.onDragCancel(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    unpressed();
    super.onDragEnd(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    unpressed();
    super.onTapUp(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    unpressed();
    super.onTapCancel(event);
  }

  void unpressed(){
    game.resetFace();
  }

  void pressed(Vector2 vector2){
    game.activeFace();
    double cellSize = game.sizeRes.cellSize;
    int x = vector2.x ~/ cellSize;
    int y = vector2.y ~/ cellSize;
    pressedAt((x, y));
  }

  void pressedAt((int, int) pos) {
    if (!_allowPressAt(pos)) return;
    print("====allowPress==$pos==============");
    _resetPrevPressed();
    _doPressAt(pos);
  }

  bool _allowPressAt((int, int) pos) {
    return _pressedCells.where((e) => e.pos == pos).isEmpty;
  }

  void _resetPrevPressed() {
    if (_pressedCells.isNotEmpty) {
      Cell lastActive = _pressedCells.removeLast();
      lastActive.reset();
    }
  }

  void _doPressAt((int, int) pos) {
    List<Cell> cells = children.whereType<Cell>().toList();
    Iterable<Cell> targets = cells.where((e) => e.pos == pos);
    if (targets.isNotEmpty) {
      Cell cell = targets.first;
      cell.pressed();
      _pressedCells.add(cell);
    }
  }


}
