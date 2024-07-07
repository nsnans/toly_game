// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-07-05
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';
import 'package:life_game/app/res/toly_icon.dart';
import 'package:tolyui/basic/basic.dart';
import 'package:tolyui/tolyui.dart';

enum ToolAction {
  play(TolyIcon.icon_play),
  next(TolyIcon.icon_next),
  prev(TolyIcon.icon_prev),
  reset(TolyIcon.icon_reset),
  clear(TolyIcon.icon_clear),
  ;

  final IconData icon;

  const ToolAction(this.icon);
}

class ActionToolbar extends StatelessWidget {
  final ValueChanged<ToolAction> onAction;

  const ActionToolbar({super.key, required this.onAction});

  @override
  Widget build(BuildContext context) {
    ActionStyle style = const ActionStyle(
      backgroundColor: Colors.black,
      padding: EdgeInsets.all(2),
      borderRadius: BorderRadius.all(Radius.circular(4)),
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: 30,
      alignment: Alignment.topCenter,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black, width: 0.5)),
      ),
      child: Wrap(
          spacing: 6,
          direction: Axis.vertical,
          children: ToolAction.values.map((e) {
            Color? color = e == ToolAction.play ? Colors.green : null;
            return TolyAction(
              style: style,
              child: Icon(e.icon, size: 18, color: color),
              onTap: () => onAction(e),
            );
          }).toList()),
    );
  }
}
