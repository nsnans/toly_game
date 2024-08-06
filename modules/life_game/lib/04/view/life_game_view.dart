// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-07-05
// Contact Me:  1981462002@qq.com

import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tolyui/basic/basic.dart';

import '../../coordinate_system/game.dart';
import '../game/game.dart';
import '../logic/frame_evolve.dart';
import '../logic/transformable/flame_transformable.dart';
import '../logic/transformable/transformable.dart';
import '../model/evolve.dart';
import 'action_toolbar.dart';
import 'ruler/ruler_painter.dart';
import 'ruler/ruler_value.dart';
import 'status_bar.dart';

class LifeGameView extends StatefulWidget {
  const LifeGameView({super.key});

  @override
  State<LifeGameView> createState() => _LifeGameViewState();
}

class _LifeGameViewState extends State<LifeGameView> {
  final LifeGame game = LifeGame();
  late ValueNotifier<EvolveStatus> _statusNtf;
  late ValueNotifier<int> _generationNtf;
  late ValueNotifier<EvolveSpeed> _speedNtf;
  final RulerValue rulerValue = RulerValue();

  // MainGame game = MainGame();

  late ValueNotifier<List<ToolAction>> _actionStateNtf;

  @override
  void initState() {
    _statusNtf = ValueNotifier(game.frameEvolve.status);
    _generationNtf = ValueNotifier(game.frameEvolve.generationCount);
    _speedNtf = ValueNotifier(game.frameEvolve.speed);
    _actionStateNtf = ValueNotifier(game.frameEvolve.actions);
    game.frameEvolve.addListener(_onEvolveChange);
    game.camera.viewfinder.transform.addListener(_onTransformChange);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _speedNtf.dispose();
    _statusNtf.dispose();
    _generationNtf.dispose();
    _actionStateNtf.dispose();
    game.frameEvolve.removeListener(_onEvolveChange);
    game.camera.viewfinder.transform.removeListener(_onTransformChange);
  }

  void _onEvolveChange() {
    EvolveStatus newStatus = game.frameEvolve.status;
    if (_statusNtf.value != newStatus) {
      _statusNtf.value = newStatus;
    }

    int newGenerationCount = game.frameEvolve.generationCount;
    if (_generationNtf.value != newGenerationCount) {
      _generationNtf.value = newGenerationCount;
    }

    EvolveSpeed newSpeed = game.frameEvolve.speed;
    if (_speedNtf.value != newSpeed) {
      _speedNtf.value = newSpeed;
    }

    List<ToolAction> newActions = game.frameEvolve.actions;
    if (_actionStateNtf.value != newActions) {
      _actionStateNtf.value = newActions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              ActionToolbar(
                status: _statusNtf,
                actions: _actionStateNtf,
                onAction: _onAction,
              ),
              Expanded(
                child: TransformWrapper(
                  onPaint: _onTapDown,
                  rulerValue: rulerValue,
                  transformable: game,
                  child: GameWidget(game: game),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1 / View.of(context).devicePixelRatio,
        ),
        StatusBar(
          generation: _generationNtf,
          onSpeedChange: (EvolveSpeed value) {
            game.frameEvolve.speed = value;
          },
          speed: _speedNtf,
        ),
      ],
    );
  }

  void _onAction(ToolAction value) {
    switch (value) {
      case ToolAction.next:
        game.nextFrame();
        break;
      case ToolAction.play:
        game.play();
        break;
      case ToolAction.see:
        game.toggleSee();
        break;
      case ToolAction.reset:
        game.reset();
        break;
      case ToolAction.clear:
        game.clear();
        break;
      case ToolAction.paint:
      case ToolAction.move:
      case ToolAction.eraser:
        game.frameEvolve.handleAction(value);
        break;
      case ToolAction.zero:
        game.fit();
    }
  }

  void _onTransformChange() {
    rulerValue.transform = game.camera.viewfinder.transform.transformMatrix.clone();
  }

  int _lastTransformTick = 0;



  void _onTapDown(Offset position) {
    if (game.frameEvolve.moveMode) return;

    int now = DateTime.now().millisecondsSinceEpoch;
    bool render = false;
    if (now-_lastTransformTick > 50) {
      render =true;
      _lastTransformTick = now;

    }

    Vector2 v2 = game.camera.viewfinder.globalToLocal(Vector2(position.dx, position.dy));
    (int, int) pos = ((v2.x / 20).floor(), (v2.y / 20).floor());

    if (game.frameEvolve.paintMode) {
      game.birth(pos,render:render);
      return;
    }

    if (game.frameEvolve.deleteMode) {
      game.died(pos,render:render );
    }
  }
}

class TransformWrapper extends StatelessWidget {
  final Widget child;
  final Transformable transformable;
  final RulerValue rulerValue;
  final ValueChanged<Offset> onPaint;

  const TransformWrapper(
      {super.key,
      required this.child,
      required this.transformable,
      required this.rulerValue,
      required this.onPaint});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerSignal: _onPointerSignal,
        onPointerMove: _onPointerMove,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            child,
            CustomPaint(
              painter: RulerPainter(rulerValue),
              child: const Center(),
            )
          ],
        ),
      ),
    );
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      bool larger = event.scrollDelta.dy < 0;
      double newZoom = larger ? 1 + 0.05 : 1 - 0.05;
      if (newZoom < 0.01 || newZoom > 20) return;
      transformable.scale(newZoom, event.localPosition);
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    transformable.translation(event.delta);
    onPaint(event.localPosition);
  }

  void _onPointerDown(PointerDownEvent event) {
    onPaint(event.localPosition);
  }
}

