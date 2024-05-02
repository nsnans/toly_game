import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_ext/flame_ext.dart';
import 'package:flutter/material.dart';
import '../app/res/extra_images.dart';
import 'logic/game_face_logic.dart';
import 'logic/game_hud_logic.dart';
import 'logic/game_state_logic.dart';
import 'model/game_state.dart';
import 'sweeper_world.dart';
import 'config/size_res.dart';

class SweeperGame extends FlameGame<SweeperWorld>
    with GameFaceLogic, GameHudLogic {
  SweeperGame() : super(world: SweeperWorld());

  late SizeRes sizeRes = SizeRes(gridXY: state.mode.size);
  TextureLoader loader = TextureLoader();

  late GameStateLogic state = GameStateLogic(const GameMode.middle(), this);

  @override
  FutureOr<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    await loader.loadSvg(extraSvg);
    changeMineCount(state.mode.mineCount);
    return super.onLoad();
  }

  void changeMode(GameMode mode){
    state = GameStateLogic(mode, this);
    sizeRes = SizeRes(gridXY: state.mode.size);
    restart();
  }

  @override
  Color backgroundColor() => const Color(0xfff7f7f0);

  void restart() {
    state.reset();
    world = SweeperWorld();
  }
}
