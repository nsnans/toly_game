// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-07-23
// Contact Me:  1981462002@qq.com

import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/game.dart';

abstract class Transformable {
  void scale(double scale, Offset origin);

  void translation(Offset delta);

  double get zoom;

  Matrix4 get transform;
}

mixin TransformableMixin implements Transformable {
  Viewfinder get transformer;

  @override
  void scale(double scale, Offset origin) {
    Matrix4 m4 = transformer.transform.transformMatrix.clone();
    // double zoom = transformer.zoom;
    print("======scale:=========");

    Vector2 center = transformer.globalToLocal(Vector2(origin.dx, origin.dy));

    Matrix4 scaleM = Matrix4.diagonal3Values(scale, scale, 0);
    Matrix4 moveM = Matrix4.translationValues(center.x, center.y, 0);
    Matrix4 backM = Matrix4.translationValues(-center.x, -center.y, 0);
    m4.multiply(moveM);
    m4.multiply(scaleM);
    m4.multiply(backM);
    if(m4.getMaxScaleOnAxis()<0.3) return;

    transformer.transform.transformMatrix = m4;
  }

  @override
  double get zoom => transformer.transform.transformMatrix.getMaxScaleOnAxis();

  @override
  void translation(Offset delta) {
    Matrix4 m4 = transformer.transform.transformMatrix;
    Matrix4 opM = Matrix4.translationValues(delta.dx, delta.dy, 0);
    opM.multiply(m4);
    transformer.transform.transformMatrix = opM;
  }
  @override
  Matrix4 get transform=> transformer.transform.transformMatrix;

}

mixin TransformGame<T extends World> on TransformableMixin, FlameGame<T > implements Transformable {
  bool get enable;

  @override
  void scale(double scale, Offset origin) {
    if (!enable||scale<0.3) return;

    super.scale(scale, origin);
    paused = false;
  }

  @override
  void translation(Offset delta) {
    if (!enable) return;
    super.translation(delta);
    paused = false;
  }

  @override
  Viewfinder get transformer => camera.viewfinder;


}
