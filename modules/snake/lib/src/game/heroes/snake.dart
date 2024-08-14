import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Snake extends PositionComponent {
  final Iterable<Point<int>> points;

  Snake(this.points);

  @override
  FutureOr<void> onLoad() {
    setFrame();
    return super.onLoad();
  }

  void setFrame() {
    removeWhere((e) => true);
    int i = 0;
    for (Point<int> point in points) {
      CellType type = i == 0 ? CellType.snakeHeader : CellType.snakeBody;
      add(Cell(point, type: type, side: 24));
      i++;
    }
  }
}

enum CellType { snakeHeader, snakeBody, food }

class Cell extends PositionComponent {
  final Point<int> point;
  final double side;
  final CellType type;

  Cell(
    this.point, {
    this.side = 20,
    this.type = CellType.snakeBody,
  }) : super(size: Vector2(side, side));

  @override
  FutureOr<void> onLoad() {
    TextStyle style =
        TextStyle(fontSize: 8, fontFamily: 'BlackOpsOne', package: 'life_game', color: textColor);
    TextComponent text = TextComponent(
      text: '${point.x},${point.y}',
      textRenderer: TextPaint(style: style),
      position: Vector2(point.x * side, point.y * side),
      anchor: Anchor.center,
    );
    add(text);
    text.position = text.position + size / 2;
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    Paint paint = Paint()..color = bodyColor;
    canvas.drawRect(Rect.fromLTWH(point.x * side, point.y * side, width, height), paint);
  }

  Color? get textColor {
    if (type == CellType.snakeHeader || type == CellType.food) return Colors.white;
    return Colors.grey;
  }

  Color get bodyColor {
    if (type == CellType.snakeHeader) return Colors.blue;
    if (type == CellType.food) return Colors.redAccent;
    return Colors.white;
  }
}
