// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-07-05
// Contact Me:  1981462002@qq.com

import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../game/game.dart';
import 'action_toolbar.dart';

class LifeGameView extends StatefulWidget {
  const LifeGameView({super.key});

  @override
  State<LifeGameView> createState() => _LifeGameViewState();
}

class _LifeGameViewState extends State<LifeGameView> {
  final LifeGame game = LifeGame();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ActionToolbar(onAction: _onAction,),
        Expanded(child: GameWidget(game: game)),
      ],
    );
  }

  void _onAction(ToolAction value) {
    switch(value){
      case ToolAction.next:
        game.nextFrame();
        break;
      case ToolAction.play:
        break;
      case ToolAction.prev:
        break;
      case ToolAction.reset:
        game.reset();
      case ToolAction.clear:
        game.clear();
    }
  }
}
