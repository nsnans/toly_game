// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-07-04
// Contact Me:  1981462002@qq.com

import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../logic/frame.dart';
import '../logic/frame_evolve.dart';
import '../view/action_toolbar.dart';
import 'space.dart';

class LifeGame extends FlameGame<LifeWord> {
  LifeGame() : super(world: LifeWord());

  Frame get frame => frameEvolve.frame;
  FrameEvolve frameEvolve = FrameEvolve((9, 9));

  @override
  FutureOr<void> onLoad() {
    camera.viewfinder.anchor = Anchor.center;
    return super.onLoad();
  }

  void play() {
    if (frameEvolve.status == EvolveStatus.evolving) {
      stop();
    } else {
      start();
    }
  }

  void start() {
    if (frameEvolve.status == EvolveStatus.evolving) {}
    paused = false;
    frameEvolve.status = EvolveStatus.evolving;
  }

  void stop() {
    paused = true;
    frameEvolve.status = EvolveStatus.stopped;
  }

  void clear() {
    paused = false;
    frame.clear();
    world.spaceManager.setFrame(frame);
  }

  void toggleSee() {
    paused = false;
    frameEvolve.handleAction(ToolAction.see);
    world.spaceManager.setFrame(frame);
  }

  void nextFrame() {
    paused = false;
    frameEvolve.evolve(world.spaceManager.setFrame);
  }

  void birth(XY pos) {
    frameEvolve.frame.birth(pos);
    paused = false;
    world.spaceManager.setFrame(frameEvolve.frame);
  }

  void died(XY pos) {
    frameEvolve.frame.died(pos);
    paused = false;
    world.spaceManager.setFrame(frameEvolve.frame);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (frameEvolve.status == EvolveStatus.stopped) {
      paused = true;
    } else {
      frameEvolve.evolve(world.spaceManager.setFrame);
    }
  }

  void reset() {
    paused = false;
    frameEvolve.reset();
    world.spaceManager.setFrame(frame);
  }
}

class LifeWord extends World with HasGameRef<LifeGame> {
  final SpaceManager spaceManager = SpaceManager();

  @override
  FutureOr<void> onLoad() {
    add(spaceManager);
    spaceManager.setFrame(game.frame);

    return super.onLoad();
  }
}
