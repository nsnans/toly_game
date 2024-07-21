// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-07-04
// Contact Me:  1981462002@qq.com

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:life_game/02/game/game.dart';
import 'package:life_game/02/logic/frame_evolve.dart';

import '../logic/frame.dart';
import '../logic/grid_action_logic.dart';

class SpaceManager extends PositionComponent
    with HasGameRef<LifeGame>,
        DragCallbacks,TapCallbacks,
        GridActionLogic
{
  final double side;
  final int row;
  final int column;

  SpaceManager({this.side = 20, this.row = 9, this.column = 9})
      : super(
          size: Vector2(side * row, side * column),
          anchor: Anchor.center,
        );

  void setFrame(Frame frame) {
    removeWhere((e) => true);
    Map<XY, bool> data = frame.spaces;
    bool see = game.frameEvolve.seeWorld;
    for (int y = 0; y < row; y++) {
      for (int x = 0; x < column; x++) {
        bool alive = data[(x, y)] == true;
        int value = frame.spaceValue((x, y));
        add(Space((x, y), alive: alive, value: value,see: see));
      }
    }
  }

  @override
  void render(Canvas canvas) {
    priority = 2;
    drawGrid(canvas, side, row, column);
  }



  void drawGrid(Canvas canvas, double boxSize, int row, int column) {
    Paint girdPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xff505050);
    Path path = Path();
    double width = row * boxSize;
    double height = column * boxSize;
    for (int i = 0; i <= column; i++) {
      path.moveTo(0, boxSize * i);
      path.relativeLineTo(width, 0);
    }
    for (int i = 0; i <= row; i++) {
      path.moveTo(boxSize * i, 0);
      path.relativeLineTo(0, height);
    }
    canvas.drawPath(path, girdPaint);
  }

  @override
  double get cellSize => side;

}

class Space extends PositionComponent {
  final XY p;
  final double side;
  final bool alive;
  final int value;
  final bool see;

  Space(
    this.p, {
    this.side = 20,
    this.alive = true,
    this.value = 0,
    this.see = false,
  }) : super(
          size: Vector2(side, side),
        );

  @override
  FutureOr<void> onLoad() {
    if(see){
      TextStyle style =
      TextStyle(fontSize: 16, fontFamily: 'BlackOpsOne', package: 'life_game', color: color);
      TextComponent text = TextComponent(
        text: '$value',
        textRenderer: TextPaint(style: style),
        position: Vector2(p.$1 * side, p.$2 * side),
        anchor: Anchor.center,
      );
      add(text);
      text.position = text.position + size / 2;
    }

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    if (!alive) return;
    Paint paint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(p.$1 * side, p.$2 * side, width, height), paint);
  }

  Color? get color {
    if (alive && (value < 2 || value > 3)) {
      return Colors.red;
    }
    if (!alive && (value <= 2 || value > 3)) {
      return Colors.grey;
    }
    return Colors.green;
  }
}
