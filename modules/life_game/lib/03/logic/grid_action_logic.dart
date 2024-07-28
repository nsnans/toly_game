// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-07-20
// Contact Me:  1981462002@qq.com

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../game/game.dart';
import 'frame.dart';

mixin GridActionLogic on DragCallbacks, TapCallbacks, HasGameRef<LifeGame>{

  double get cellSize;

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

  void pressed(Vector2 vector2) {
    XY position = trans(vector2);
    bool alive = game.frameEvolve.frame.spaces[position]==true;
    if(game.frameEvolve.paintMode){
      if(!alive){
        game.birth(position);
      }
    }
    if(game.frameEvolve.deleteMode){
      if(alive){
        game.died(position);
      }
    }
  }

  XY trans(Vector2 vector2) {
    int x = vector2.x ~/ cellSize;
    int y = vector2.y ~/ cellSize;
    return (x, y);
  }
}