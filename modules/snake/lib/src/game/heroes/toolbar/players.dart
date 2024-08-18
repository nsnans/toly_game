import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PlayerBar extends PositionComponent {
  TextStyle style = TextStyle(
      fontSize: 16, fontFamily: 'BlackOpsOne', package: 'life_game', color: Color(0xff00ffff));
  late TextComponent text = TextComponent(
    text: 'Player1:',
    textRenderer: TextPaint(style: style),
    // position: Vector2(point.x * side, point.y * side),
    // anchor: Anchor.center,
  );

  RectangleComponent rect = RectangleComponent(size: Vector2(20,20));

  void setScore(int value) {
    text.text = 'Player1: $value';
  }



  @override
  void onParentResize(Vector2 maxSize) {
    text.position = Vector2(20, (maxSize.y - text.height) / 2);
    rect.position= Vector2(text.width+20+8, (maxSize.y - 20) / 2);
    super.onParentResize(maxSize);
  }

  @override
  FutureOr<void> onLoad() {
    add(text);
    Paint paint =Paint()..color=Colors.blue;
    rect.paint=paint;
    add(rect);
    return super.onLoad();
  }
}
