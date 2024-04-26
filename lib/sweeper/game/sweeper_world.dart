import 'dart:async';
import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:toly_game/sweeper/game/heros/cell.dart';
import 'package:toly_game/world/14/world_grid.dart';

import '../../world/11/heroes/line.dart';
import 'heros/sweeper_hud.dart';
import 'heros/sweeper_playground.dart';
import 'sweeper_game.dart';

class SweeperWorld extends World{
  @override
  FutureOr<void> onLoad() {
    // add(Line());
    SweeperHud hud = SweeperHud()..y=68;
    add(hud);
    add(SweeperPlayground()..y=46+68+6);
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

  void pressed((int,int) pos){
    SweeperPlayground ground = children.whereType<SweeperPlayground>().first;
    CellManager manager = ground.children.whereType<CellManager>().first;
    List<Cell> cells = manager.children.whereType<Cell>().toList();
    for(Cell cell in cells){
      if(cell.pos==pos){
        cell.pressed();
      }else{
        cell.reset();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // print("=========================");

    // canvas.drawRect(Rect.fromLTWH(0, 0, kViewPort.width, kViewPort.height), Paint());
    // _worldGrid.paint(canvas, kViewPort);
  }
}
