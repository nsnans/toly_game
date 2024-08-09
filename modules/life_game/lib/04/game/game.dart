// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-07-04
// Contact Me:  1981462002@qq.com

import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/src/camera/viewfinder.dart';
import 'package:flutter/services.dart';
import 'package:life_game/03/game/ruler.dart';

import '../logic/frame.dart';
import '../logic/frame_evolve.dart';
import '../logic/throttle.dart';
import '../logic/transformable/flame_transformable.dart';
import '../logic/transformable/transformable.dart';
import '../view/action_toolbar.dart';
import 'space.dart';

class LifeGame extends FlameGame<LifeWord> with TransformableMixin, TransformGame<LifeWord> {
  LifeGame() : super(world: LifeWord());

  Frame get frame => frameEvolve.frame;
  FrameEvolve frameEvolve = FrameEvolve();

  List<XY> points = [];

  @override
  FutureOr<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.center;
    String data = await rootBundle.loadString(
      'assets/data/points.json',
    );
    points = jsonDecode(data)
        .map<XY>((e) => (int.parse(e[0].toString()), int.parse(e[1].toString())))
        .toList();
    frameEvolve.frame.setData(points);
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
    world.setFrame(frame);
  }

  void toggleSee() {
    paused = false;
    frameEvolve.handleAction(ToolAction.see);
    world.setFrame(frame);
  }

  void nextFrame() {
    paused = false;
    frameEvolve.evolve(world.setFrame);
  }

  void birth(XY pos, {bool render = true}) {
    frameEvolve.frame.birth(pos);
    if (render) {
      paused = false;
      world.setFrame(frameEvolve.frame);
    }
  }

  void died(XY pos, {bool render = true}) {
    frameEvolve.frame.died(pos);
    if (render) {
      paused = false;
      world.setFrame(frameEvolve.frame);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (frameEvolve.status == EvolveStatus.stopped) {
      paused = true;
    } else {
      frameEvolve.evolve(world.setFrame);
    }
  }

  void reset() {
    paused = false;
    frameEvolve.reset();
    world.setFrame(frame);
  }

  @override
  bool get enable => frameEvolve.moveMode;

  void fit() {
    camera.viewfinder.transform.transformMatrix =
        Matrix4.translationValues(size.x / 2, size.y / 2, 0);
  }

  @override
  void onTransformTick() {
    world.setFrame(frame);
  }

}

class LifeWord extends World with HasGameRef<LifeGame> {

  late Throttled<Frame> _throttled;
  late Throttled<Frame> _throttledPainter;

  @override
  FutureOr<void> onLoad() {
    _throttled = throttle(duration: const Duration(milliseconds: 100), function: _render);
    _throttledPainter = throttle(duration: const Duration(milliseconds: 50), function: _render);
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _throttled(game.frame);
  }

  void setFrame(Frame frame) {
    if(game.frameEvolve.moveMode){
      _throttled(frame);
    }else{
      _throttledPainter(frame);
    }
  }

  void _render(Frame frame) {
    removeWhere((e) => true);
    final SpaceManager spaceManager = SpaceManager(game.frame);
    add(spaceManager);
    game.paused=false;
  }
}


