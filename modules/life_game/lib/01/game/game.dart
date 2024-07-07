// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-07-04
// Contact Me:  1981462002@qq.com

import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:life_game/01/game/space.dart';

import '../logic/frame_v1_map.dart';

class LifeGame extends FlameGame<LifeWord> {
  LifeGame() : super(world: LifeWord());

  Frame frame = Frame((9,9));

  @override
  FutureOr<void> onLoad() {
    camera.viewfinder.anchor = Anchor.center;
    return super.onLoad();
  }

  void clear() {
    paused = false;
    frame.clear();
    world.spaceManager.setFrame(frame);
  }

  void nextFrame() {
    paused = false;
    frame.evolve();
    world.spaceManager.setFrame(frame);
  }

  @override
  void update(double dt) {
    super.update(dt);
    paused = true;
    print("======update==========");
  }

  void reset() {
    paused = false;
    frame.reset();
    world.spaceManager.setFrame(frame);
  }
}

class LifeWord extends World with HasGameRef<LifeGame> {

  final SpaceManager spaceManager = SpaceManager();

  @override
  FutureOr<void> onLoad() {
    spaceManager.setFrame(game.frame);
    add(spaceManager);
    return super.onLoad();
  }

}