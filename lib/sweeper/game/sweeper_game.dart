import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_ext/flame_ext.dart';
import 'package:toly_game/sweeper/game/heros/cell.dart';
import '../app/res/extra_images.dart';
import 'sweeper_world.dart';

// const Size kViewPort = Size( 16*36 ,16*36,);

class SweeperGame extends FlameGame<SweeperWorld>{

  SweeperGame():super(
    world: SweeperWorld(),
    // camera: CameraComponent.withFixedResolution(
    //     width:kViewPort.width,
    //     height: kViewPort.height,
    // )

  );

  TextureLoader loader = TextureLoader();


  @override
  FutureOr<void> onLoad() async{

    camera.viewfinder.anchor = Anchor.topLeft;
    // camera.moveTo(Vector2(-(width-cellSize*gridSize.$1)/2, 0));
   await loader.loadImages(extraImages);
    add(FpsTextComponent()..x=20..y=20);

    return super.onLoad();
  }

  @override
  Color backgroundColor() {

    return Color(0xfff7f7f0);
  }
}