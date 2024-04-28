import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../painter/decration/border_decroation.dart';
import '../config/color_res.dart';
import '../sweeper_game.dart';
import 'cell/cell.dart';
import 'cell/cell_manager.dart';
import 'hud/sweeper_hud.dart';

class SweeperLayout extends PositionComponent with HasGameRef<SweeperGame> {
  @override
  void onGameResize(Vector2 size) {
    x = (size.x - width) / 2;
    y = (size.y - height) / 2;
    super.onGameResize(size);
  }

  @override
  FutureOr<void> onLoad() {
    size = game.sizeRes.layoutSize;
    double gap = game.sizeRes.gap;
    SweeperHud hud = SweeperHud()..position = Vector2(gap, gap);
    //
    add(hud);
    add(CellManager());
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    Rect rect = Offset.zero & Size(width, height);
    canvas.drawRect(rect, Paint()..color = ColorRes.background);
    _pintHudBorder(canvas);
    _paintGridBorder(canvas);
    _paintOutBorder(canvas,rect);
    super.render(canvas);
  }

  void _pintHudBorder(Canvas canvas) {
    double strokeWidth = game.sizeRes.gap * 0.35;
    BorderDecoration decoration = BorderDecoration(
      strokeWidth: strokeWidth,
      top: ColorRes.gray,
      left: ColorRes.gray,
      right: ColorRes.white,
      bottom: ColorRes.white,
    );
    decoration.paint(game.sizeRes.hudRect, canvas);
  }

  void _paintGridBorder(Canvas canvas) {
    double strokeWidth = game.sizeRes.gap * 0.42;
    BorderDecoration decoration = BorderDecoration(
      strokeWidth: strokeWidth,
      top: ColorRes.gray,
      left: ColorRes.gray,
      right: ColorRes.white,
      bottom: ColorRes.white,
    );
    decoration.paint(game.sizeRes.gridRect, canvas);
  }

  void _paintOutBorder(Canvas canvas,Rect rect) {
    double strokeWidth = game.sizeRes.gap * 0.25;
    BorderDecoration decoration = BorderDecoration(
      strokeWidth: strokeWidth,
      top: ColorRes.white,
      left: ColorRes.white,
      right: ColorRes.gray,
      bottom: ColorRes.gray,
    );
    decoration.paint(rect, canvas);
  }

}
