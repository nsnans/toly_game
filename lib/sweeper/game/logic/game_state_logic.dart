import 'dart:math';

import '../../../utils/toast.dart';
import '../model/game_state.dart';
import 'game_hud_logic.dart';
import '../model/types.dart';

class GameStateLogic {
  final GameMode mode;

  final GameHudLogic logic;

  GameStateLogic(this.mode, this.logic);

  GameStatus _status = GameStatus.ready;

  final Random _random = Random();

  final List<XY> _openPos = [];
  final List<XY> _markPos = [];

  void lose() {
    _status = GameStatus.died;
    logic.closeTimer();
  }

  bool get disable => _status == GameStatus.died || _status == GameStatus.win;

  bool isMarked(XY pos) {
    return _markPos.contains(pos);
  }

  bool get isWin {
    //胜利条件
    return _openPos.length == mode.row * mode.column - mode.mineCount;
  }

  int get ledMineCount => mode.mineCount - _markPos.length;

  void reset() {
    _status = GameStatus.ready;
    logic.closeTimer();
    _openPos.clear();
    _markPos.clear();
    cells.clear();
  }

  bool isOpen(XY pos) {
    return _openPos.contains(pos);
  }

  bool allowOutOpen(XY pos) {
    return !isOpen(pos) && !isMarked(pos);
  }

  void initMapOrNot(XY pos) {
    if (_openPos.isEmpty) {
      _status = GameStatus.playing;
      logic.startTimer();
      _createMine(pos, mode.row, mode.column);
      _createCellValue();
    }
  }

  bool open(XY pos) {
    _openPos.add(pos);
    checkWinGame();
    return isWin;
  }

  void checkWinGame() {
    if (isWin) {
      Toast.success('恭喜胜利');
      _status = GameStatus.win;
      logic.closeTimer();
    }
  }

  void mark(XY pos) {
    _markPos.add(pos);
  }

  Map<XY, CellType> cells = {};

  void _createMine(XY pos, int row, int column) {
    List<XY> posPool = [];
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < column; j++) {
        if (pos != (j, i)) {
          posPool.add((j, i));
        }
      }
    }
    while (cells.length < mode.mineCount) {
      int index = _random.nextInt(posPool.length);
      XY target = posPool[index];
      cells[target] = CellType.mine;
      posPool.remove(target);
    }
  }

  void _createCellValue() {
    int row = mode.row;
    int column = mode.column;
    for (int y = 0; y < row; y++) {
      for (int x = 0; x < column; x++) {
        if (cells[(x, y)] != CellType.mine) {
          int count = _calculate(x, y, row, column);
          cells[(x, y)] = CellType.values[count];
        }
      }
    }
  }

  int _calculate(int x, int y, int row, int column) {
    int count = 0;
    for (int i = max(0, y - 1); i <= min(row - 1, y + 1); i++) {
      for (int j = max(0, x - 1); j <= min(column - 1, x + 1); j++) {
        if (cells[(j, i)] == CellType.mine) count++;
      }
    }
    return count;
  }

  void unMark((int, int) pos) {
    _markPos.remove(pos);
  }
}
