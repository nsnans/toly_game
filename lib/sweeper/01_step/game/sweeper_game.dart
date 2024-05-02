import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_ext/flame_ext.dart';
import 'package:flutter/material.dart';
import '../app/res/extra_images.dart';
import 'logic/game_face_logic.dart';
import 'sweeper_world.dart';
import 'config/size_res.dart';
// const Size kViewPort = Size( 16*36 ,16*36,);

class SweeperGame extends FlameGame<SweeperWorld> with GameFaceLogic{

  SweeperGame():super(world: SweeperWorld());

  SizeRes sizeRes = SizeRes();
  TextureLoader loader = TextureLoader();



  @override
  FutureOr<void> onLoad() async{

    camera.viewfinder.anchor = Anchor.topLeft;
    // camera.moveTo(Vector2(-(width-cellSize*gridSize.$1)/2, 0));
   await loader.loadImages(extraImages);
   await loader.loadSvg(extraSvg);
    add(FpsTextComponent(
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 16,color: Colors.black)
      )
    )..x=20..y=20);

    return super.onLoad();
  }

  @override
  Color backgroundColor() {

    return Color(0xfff7f7f0);
  }
}