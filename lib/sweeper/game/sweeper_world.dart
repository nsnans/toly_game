import 'dart:async';
import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:toly_game/world/14/world_grid.dart';

import 'heroes/sweeper_layout.dart';

class SweeperWorld extends World{



  @override
  FutureOr<void> onLoad() {
    // add(Line());
   add( SweeperLayout());


    // add(Cell(0));
    // add(Cell(1)..x=36);
;
    // add(CircleComponent(radius: 60,));

    return super.onLoad();
  }


  final WorldGrid _worldGrid = WorldGrid(
    axisColor: Colors.red,
    textColor: Colors.white,
    gridColor: const Color(0xff4AFFFF),
  );

  @override
  void render(Canvas canvas) {
    // print("=========================");

    // canvas.drawRect(Rect.fromLTWH(0, 0, kViewPort.width, kViewPort.height), Paint());
    // _worldGrid.paint(canvas, kViewPort);
  }
}
