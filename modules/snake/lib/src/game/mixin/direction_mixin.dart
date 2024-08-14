import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Direction {
  up,
  down,
  left,
  right;

  Direction get opposite {
    return switch (this) {
      up => down,
      down => up,
      left => right,
      right => left,
    };
  }
}

abstract class DirectionChange {
  void onDirectionChange(Direction direction);

  void onStart();
}

mixin DirectionCtrlMixin on KeyboardEvents implements DirectionChange {
  Direction lastDirection = Direction.up;

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      Direction? direction = calcDirection(keysPressed);
      if(direction!=null){
        tickDirectionChange(direction);
      }

      if(keysPressed.contains(LogicalKeyboardKey.space)){
        onStart();
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void tickDirectionChange(Direction? direction){
    bool allow = direction != null && lastDirection.opposite != direction;
    if (allow) {
      onDirectionChange(direction);
      lastDirection = direction;
    }
  }

  Direction? calcDirection(Set<LogicalKeyboardKey> keysPressed) {
    final isArrowDown = keysPressed.contains(LogicalKeyboardKey.arrowDown);
    if (isArrowDown) return Direction.down;

    final isArrowLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    if (isArrowLeft) return Direction.left;

    final isArrowUp = keysPressed.contains(LogicalKeyboardKey.arrowUp);
    if (isArrowUp) return Direction.up;

    final isArrowRight = keysPressed.contains(LogicalKeyboardKey.arrowRight);
    if (isArrowRight) return Direction.right;
    return null;
  }
}
