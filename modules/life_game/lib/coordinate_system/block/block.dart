// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-07-23
// Contact Me:  1981462002@qq.com

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../03/logic/frame.dart';
import '../game.dart';

class BlockManager extends PositionComponent with HasGameRef<MainGame> {
  BlockManager() : super(priority: 2);

  final double side = 40;

  @override
  void onGameResize(Vector2 size) {
    int windowXCapacity = game.size.x ~/ side + 2;
    int windowYCapacity = game.size.y ~/ side + 2;

    this.size = Vector2(side * windowXCapacity, side * windowYCapacity);
    _initCooData((0,0),1);
    super.onGameResize(size);
  }
  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;

    return super.onLoad();
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

  void transformChange(XY move,double scale){
    _initCooData(move,scale);
  }


  void _initCooData(XY move,double scale) {
    return;
    removeWhere((e) => true);
    double side = this.side*scale;
    int cacheSize = 4;
    int windowXCapacity = game.size.x ~/ (side) + 2;
    int windowYCapacity = game.size.y ~/ (side) + 2;
    print("$windowXCapacity,$windowYCapacity");

    int centerX = windowXCapacity ~/ 2;
    int centerY = windowYCapacity ~/ 2;
    XY offset = move;
    // Grid grid = Grid(this.side,scale)..position = Vector2(side*offset.$1,side*offset.$2);
    // add(grid);
    // grid.position = grid.position+;
    for (int i = -cacheSize ~/ 2; i < windowXCapacity + cacheSize ~/ 2; i++) {
      for (int j = -cacheSize ~/ 2; j < windowYCapacity + cacheSize ~/ 2; j++) {
        bool isCache = i < 0 || i >= windowXCapacity || j < 0 || j >= windowYCapacity;
        add(Block((i - centerX+offset.$1, (j - centerY+offset.$2)), side: this.side, cache: isCache)
          ..position = Vector2(centerX * this.side + 0.5 * this.side, centerY * this.side + 0.5 * this.side));
      }
    }

    // add(Block((0,0),side: side));
  }
}

class Grid extends PositionComponent with HasGameRef<MainGame> {
  final double side;
  final double scaleValue;

  Grid(this.side,this.scaleValue) : super(priority: 99);

  @override
  void onGameResize(Vector2 size) {
    int windowXCapacity = game.size.x ~/ (side*scaleValue) + 2;
    int windowYCapacity = game.size.y ~/  (side*scaleValue) + 2;

    this.size = Vector2(side * windowXCapacity, side * windowYCapacity);

    super.onGameResize(size);
  }

  @override
  void render(Canvas canvas) {
    int windowXCapacity = game.size.x ~/  (side*scaleValue) + 2;
    int windowYCapacity = game.size.y ~/  (side*scaleValue) + 2;

    drawGrid(canvas, side, windowXCapacity, windowYCapacity);
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
}

class Block extends PositionComponent {
  final XY p;
  final double side;
  final bool alive;
  final int value;
  final bool see;
  final bool cache;

  Block(
    this.p, {
    this.side = 30,
    this.alive = true,
    this.value = 0,
    this.see = true,
    this.cache = false,
  }) : super(size: Vector2(side, side), anchor: Anchor.center, priority: 1);

  @override
  FutureOr<void> onLoad() {
    if (see) {
      TextStyle style =
          TextStyle(fontSize: 10, fontFamily: 'BlackOpsOne', package: 'life_game', color: color);
      TextComponent text = TextComponent(
        text: '${p.$1},${p.$2}',
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
    Paint paint = Paint()..color = paintColor;
    canvas.drawRect(Rect.fromLTWH(p.$1 * side, p.$2 * side, width, height), paint);
    // canvas.drawRect(
    //     Rect.fromLTWH(p.$1 * side, p.$2 * side, width, height),
    //     paint
    //       ..style = PaintingStyle.stroke
    //       ..color = Colors.grey);
  }

  Color get color {
    if (p.$1 == 0 || p.$2 == 0) {
      return Colors.white;
    }

    return Colors.grey;
  }

  Color get paintColor {
    if (p.$1 == 0 || p.$2 == 0) {
      return Colors.blue;
    }
    if (cache) {
      return Colors.yellow;
    }

    return Colors.white;
  }
}
