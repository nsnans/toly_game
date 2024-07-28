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

import '../../coordinate_system/game.dart';
import '../game/game.dart';
import '../logic/frame_evolve.dart';
import '../logic/transformable.dart';
import '../model/evolve.dart';
import 'action_toolbar.dart';
import 'ruler/ruler_painter.dart';
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

  late ValueNotifier<List<ToolAction>> _actionStateNtf;

  @override
  void initState() {
    _statusNtf = ValueNotifier(game.frameEvolve.status);
    _generationNtf = ValueNotifier(game.frameEvolve.generationCount);
    _speedNtf = ValueNotifier(game.frameEvolve.speed);
    _actionStateNtf = ValueNotifier(game.frameEvolve.actions);
    game.frameEvolve.addListener(_onEvolveChange);
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
    MainGame game = MainGame();
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
            // game.frameEvolve.speed = value;
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
    }
  }
}

class TransformWrapper extends StatefulWidget {
  final Widget child;
  final Transformable transformable;

  const TransformWrapper({super.key, required this.child, required this.transformable});

  @override
  State<TransformWrapper> createState() => _TransformWrapperState();
}

class _TransformWrapperState extends State<TransformWrapper> {
  final RulerValue rulerValue = RulerValue();

  @override
  void initState() {
    super.initState();
    rulerValue.tansform = widget.transformable.transform;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerSignal: _onPointerSignal,
        onPointerMove: _onPointerMove,
        child: Stack(
          children: [
            widget.child,
            CustomPaint(
              painter: RulerPainter(rulerValue),
              child: Center(),
            )
          ],
        ),
      ),
    );
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      bool larger = event.scrollDelta.dy < 0;
      double curZoom = 1;
      double newZoom = 0;
      if (larger) {
        newZoom = curZoom + 0.05;
      } else {
        newZoom = curZoom - 0.05;
      }
      if (newZoom < 0.01 || newZoom > 20) return;

      widget.transformable.scale(newZoom, event.localPosition);

      rulerValue.tansform = widget.transformable.transform;

      // rulerValue.scaleCenter = event.localPosition;
      // rulerValue.scale = widget. transformable.zoom;

      // bool larger = event.scrollDelta.dy < 0;
      // double curZoom = rulerValue.scale;
      // double newZoom = 0;
      // if (larger) {
      //   newZoom = curZoom + 0.01;
      // } else {
      //   newZoom = curZoom - 0.01;
      // }
      // if (newZoom < 0.01 || newZoom > 20) return;
      // rulerValue.scale = newZoom;
      // rulerValue.scaleCenter = event.localPosition;
      // widget.transformable.scale(larger?0.01:-0.01, event.localPosition);
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    // rulerValue.pos = event.localPosition;
    // rulerValue.shift += event.delta.dx;
    widget.transformable.translation(event.delta);
    rulerValue.tansform = widget.transformable.transform;
  }

  void _onPointerDown(PointerDownEvent event) {
    rulerValue.pos = event.localPosition;
    rulerValue.shift += event.delta.dx;
    // Viewfinder viewfinder = game.camera.viewfinder;
    // Offset origin = event.localPosition;
    //
    // Vector2 vector2 = viewfinder.globalToLocal(Vector2(origin.dx, origin.dy));
    // print("====_onPointerDown:${origin}====vector2:${vector2}====");
  }
}

class RulerValue extends ChangeNotifier {
  Matrix4 _tansform = Matrix4.identity();

  Matrix4 get tansform => _tansform;

  set tansform(Matrix4 value) {
    _tansform = value;
    notifyListeners();
  }

  double _shift = 0;

  double get shift => _shift;

  set shift(double value) {
    _shift = value;
    notifyListeners();
  }

  double _scale = 1;

  double get scale => _scale;

  double? orgOffset;

  set scale(double value) {
    _scale = value;
    notifyListeners();
  }

  Offset pos = Offset.zero;
  Offset? scaleCenter;
}

class TransformData {
  final Offset c;
  final double s;

  TransformData({
    required this.c,
    required this.s,
  });
}

class RangeZone {
  final Area x;
  final Area y;

  RangeZone({
    required this.x,
    required this.y,
  });

  (double, double) transform(Area area, double c, double s) {
    double len = area.b - area.a;
    double lenL = c - area.a;
    double lenR = area.b - c;
    return (
      c - len / s * (lenL / len) - c,
      c + len / s * (lenR / len) - c,
    );
  }

  List<ScaleBox> xBoxes(double side, TransformData data) {
    var (start, end) = transform(x, data.c.dx, data.s);
    List<ScaleBox> boxes = [];
    for (int i = start ~/ side - 1; i < end ~/ side + 1; i++) {
      boxes.add(ScaleBox(i, side * data.s, Axis.horizontal));
    }
    return boxes;
  }

  List<ScaleBox> yBoxes(double side, TransformData data) {
    var (start, end) = transform(x, data.c.dy, data.s);
    List<ScaleBox> boxes = [];
    for (int i = start ~/ side - 1; i < end ~/ side + 1; i++) {
      boxes.add(ScaleBox(i, side * data.s, Axis.vertical));
    }
    return boxes;
  }
}

class Area {
  final double a;
  final double b;

  Area(this.a, this.b);

  @override
  String toString() {
    return 'Area[${a.toStringAsFixed(1)} ~ ${b.toStringAsFixed(1)}]';
  }
}

class ScaleBox {
  final int value;
  final Axis axis;
  final double width;

  ScaleBox(this.value, this.width, this.axis);

  void paintText(TextPainter painter, Canvas canvas, double extend) {
    painter.text = TextSpan(text: '$value', style: const TextStyle(fontSize: 12));
    painter.layout();

    Offset offset = switch (axis) {
      Axis.horizontal => Offset(
          value * width + width / 2 - painter.size.width / 2,
          extend / 2 - painter.size.height / 2,
        ),
      Axis.vertical => Offset(
          extend / 2 - painter.size.width / 2,
          value * width + width / 2 - painter.size.height / 2,
        ),
    };

    painter.paint(canvas, offset);
  }
}
