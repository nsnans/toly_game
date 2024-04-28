import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/material.dart';

import '../../config/color_res.dart';
import '../../sweeper_game.dart';
import 'face_button.dart';
import 'led_screen.dart';

class SweeperHud extends PositionComponent with HasGameRef<SweeperGame> {
  @override
  FutureOr<void> onLoad() {
    size = game.sizeRes.hudSize;
    _addLedScreen();
    double faceY = (height - game.sizeRes.faceSize.y) / 2;
    double faceX = (width - game.sizeRes.faceSize.x) / 2;
    add(FaceButton()..position = Vector2(faceX, faceY));
    return super.onLoad();
  }

  void _addLedScreen(){
    double ledWidth = game.sizeRes.ledWidth;
    double ledSpace = game.sizeRes.ledSpace;
    LedScreen left = LedScreen(ledSpace: ledSpace,ledWidth: ledWidth);
    double ledY = (height - left.screenSize.y) / 2;
    double ledX = ledWidth/2;
    left.position = Vector2(ledX, ledY);
    add(left);

    LedScreen right =  LedScreen(ledSpace: ledSpace,ledWidth: ledWidth,count: 4);
    ledX = width - ledWidth/2 - right.screenSize.x;
    right.position = Vector2(ledX, ledY);
    add(right);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Offset.zero & Size(width, height),
      Paint()..color = ColorRes.background,
    );
    super.render(canvas);
  }
}
