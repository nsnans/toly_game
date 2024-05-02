import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../heroes/cell/cell.dart';
import '../model/types.dart';
import '../model/game_state.dart';
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
  void onLongTapDown(TapDownEvent event) {
    if (game.state.disable) return;
    print("========onLongTapDown=============");
    XY pos = trans(event.localPosition);
    if (game.state.isOpen(pos)) return;
    Cell? cell = activeCell(pos);
    if (cell != null) {
      cell.mark();
      unpressed();
    }
    super.onLongTapDown(event);
  }

  Cell? activeCell(XY pos) {
    List<Cell> cells = children.whereType<Cell>().toList();
    Iterable<Cell> targets = cells.where((e) => e.pos == pos);
    if (targets.isNotEmpty) {
      return targets.first;
    }
    return null;
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
    open();
    super.onDragEnd(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    open();
    super.onTapUp(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    unpressed();
    super.onTapCancel(event);
  }

  void open() {
    if (game.state.disable) return;
    if (_pressedCells.isNotEmpty) {
      Cell cell = _pressedCells.first;
      if (game.state.isMarked(cell.pos)) {
        cell.reset();
        return;
      }
      game.state.initMapOrNot(cell.pos);
      _debugOpenAll();
      CellType? type = game.state.cells[cell.pos];
      if (type == CellType.mine) {
        died(cell);
      } else {
        cell.open();
        handleAutoOpen(cell.pos);
      }
      _pressedCells.clear();
    }
    unpressed();
  }

  void died(Cell cell) {
    game.emit(FaceType.lose);
    game.state.lose();
    Iterable<Cell> cells = children.whereType<Cell>();
    for (Cell cell in cells) {
      cell.openMind();
    }
    cell.died();
  }

  void autoOpenAt((int, int) pos) {
    Cell? cell = activeCell(pos);
    if (cell != null) {
      CellType? type = game.state.cells[pos];
      if (type != CellType.mine) {
        cell.open();
        handleAutoOpen(pos);
      }
    }
  }

  void handleAutoOpen((int, int) pos) {
    CellType? type = game.state.cells[pos];
    int row = game.state.mode.row;
    int column = game.state.mode.column;
    int i = pos.$2;
    int j = pos.$1;
    if (type == CellType.value0) {
      for (int i2 = max(0, i - 1); i2 <= min(row - 1, i + 1); i2++) {
        for (int j2 = max(0, j - 1); j2 <= min(column - 1, j + 1); j2++) {
          if (game.state.allowOutOpen((j2, i2))) {
            autoOpenAt((j2, i2));
          }
        }
      }
    }
  }

  void unpressed() {
    if (game.state.disable) return;
    _pressedCells.clear();
    game.emit(FaceType.common);
  }

  void pressed(Vector2 vector2) {
    if (game.state.disable) return;
    game.emit(FaceType.active);
    pressedAt(trans(vector2));
  }

  XY trans(Vector2 vector2) {
    double cellSize = game.sizeRes.cellSize;
    int x = vector2.x ~/ cellSize;
    int y = vector2.y ~/ cellSize;
    return (x, y);
  }

  void pressedAt((int, int) pos) {
    if (!_allowPressAt(pos)) return;
    _resetPrevPressed();
    _doPressAt(pos);
  }

  bool _allowPressAt((int, int) pos) {
    return !game.state.isOpen(pos) &&
        _pressedCells.where((e) => e.pos == pos).isEmpty;
  }

  void _resetPrevPressed() {
    if (_pressedCells.isNotEmpty) {
      Cell lastActive = _pressedCells.removeLast();
      lastActive.reset();
    }
  }

  void _doPressAt((int, int) pos) {
    Cell? cell = activeCell(pos);
    if (cell != null) {
      if (game.state.isMarked(cell.pos)) {
        cell.unMark();
        return;
      }
      cell.pressed();
      _pressedCells.add(cell);
    }
  }

  void _showAllFlag(){
    List<XY> v = game.state.cells.keys.toList();
    for(int i =0;i<v.length;i++){
      CellType? type = game.state.cells[v[i]];
      if(type==CellType.mine){
        activeCell(v[i])?.mark();
      }
    }
  }

  void _debugOpenAll(){
    List<XY> v = game.state.cells.keys.toList();
    for(int i =0;i<v.length;i++){
      CellType? type = game.state.cells[v[i]];
      activeCell(v[i])?.open();
    }
  }
}
