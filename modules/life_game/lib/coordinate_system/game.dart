// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-07-23
// Contact Me:  1981462002@qq.com

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' hide Image,Hero;
import 'package:flutter/services.dart';

import '../03/game/ruler.dart';
import '../03/logic/transformable.dart';
import 'block/block.dart';
import 'help_text.dart';
import 'world_grid.dart';

class MainGame extends FlameGame<PlayWord> with KeyboardEvents, TransformableMixin, TransformGame{
  MainGame()
      : super(
    world: PlayWord(),
  );

  late final Image spriteImage;
  @override
  Future<void> onLoad() async {
    spriteImage = await Flame.images.load('demos/c17_mini_rmbg.png');
    // add(Ruler()..priority=100);

    // add(FpsText(color: Colors.white));
;


  }


  double deltaX = 0;
  double deltaY = 0;
  int _offsetX = 0;
  int _offsetY = 0;


  @override
  void scale(double scale, Offset origin) {
    super.scale(scale,origin);
    double s = transformer.transform.transformMatrix.getMaxScaleOnAxis();

    // world.blockManager.transformChange((-_offsetX,-_offsetX),s);
  }


  @override
  void translation(Offset delta) {
    super.translation(delta);
    deltaX+=delta.dx;
    deltaY+=delta.dy;
    double scale = transformer.transform.transformMatrix.getMaxScaleOnAxis();
    // Vector2 v2=  transformer.localToGlobal(Vector2(v3.x, v3.y  ));
    // print("====${v3.x}===${v3.y}=====$deltaX====");
    int offsetX = deltaX~/(40*scale);
    int offsetY = deltaY~/(40*scale);
    if(_offsetX!=offsetX||offsetY!=_offsetY){
      _offsetX = offsetX;
      _offsetY = offsetY;
      world.blockManager.transformChange((-_offsetX,-_offsetY),scale);
    }

  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowDown:
          camera.viewfinder.position -= Vector2(0, 10);
      // camera.moveBy(Vector2(0, -10));
        case LogicalKeyboardKey.arrowUp:
          camera.viewfinder.position += Vector2(0, 10);
      // camera.moveBy(Vector2(0, 10));
        case LogicalKeyboardKey.arrowLeft:
        // camera.moveBy(Vector2(10, 0));
          camera.viewfinder.position += Vector2(10, 0);
        case LogicalKeyboardKey.arrowRight:
          camera.viewfinder.position += Vector2(-10, 0);
        case LogicalKeyboardKey.bracketLeft:
          camera.viewfinder.zoom += 0.1;
        case LogicalKeyboardKey.bracketRight:
          double newZoom = camera.viewfinder.zoom-0.1;
          camera.viewfinder.zoom = max(0.1, newZoom);
        case LogicalKeyboardKey.keyR:
          camera.viewfinder.zoom = 1;
          camera.viewfinder.position=Vector2(0, 0);
          camera.viewfinder.angle=0;
        case LogicalKeyboardKey.keyT:
          camera.viewfinder.angle-= 2*(pi/180);
      }
    }

    return KeyEventResult.handled;
  }

  // @override
  // Color backgroundColor() => const Color(0xff5EC8F8);

  @override
  bool get enable => true;
}

class PlayWord extends World {

  final BlockManager blockManager = BlockManager();


  @override
  FutureOr<void> onLoad() {
    // add(Ruler()..priority=100);
    add(blockManager);

    return super.onLoad();
  }


  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

}

