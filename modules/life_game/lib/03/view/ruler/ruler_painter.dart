// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-07-28
// Contact Me:  1981462002@qq.com

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../life_game_view.dart';

class RulerPainter extends CustomPainter {
  final RulerValue value;

  RulerPainter(this.value) : super(repaint: value);

  final TextPainter _textPainter = TextPainter(textDirection: TextDirection.ltr);

  final Paint _storkPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.white;

  final Paint _gridPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.grey
    ..strokeWidth = 0.5;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xff2a2a2a));
    canvas.drawRect(
        Rect.fromLTWH(20, 20, size.width - 20, size.height - 20), Paint()..color = Colors.black);

    Vector3 tr = value.tansform.getTranslation();
    double side = 40;
    double scaleExtend = 20;

    double s = value.tansform.getMaxScaleOnAxis();
    Offset c = value.tansform.getTranslation().xy.toOffset();

    RangeZone zone = RangeZone(x: Area(0, size.width), y: Area(0, size.height));
    TransformData data = TransformData(c: c, s: s);

    List<ScaleBox> xBoxes = zone.xBoxes(side, data);
    List<ScaleBox> yBoxes = zone.yBoxes(side, data);

    drawGrid(canvas, size, c, xBoxes, yBoxes, scaleExtend);
    drawScale(canvas, size, c, xBoxes, yBoxes, scaleExtend);

    AxisPainter axis = AxisPainter(size);
    axis.paint(canvas, _textPainter, tr.xy.toOffset());
  }

  void drawScale(
    Canvas canvas,
    Size size,
    Offset c,
    List<ScaleBox> xBoxes,
    List<ScaleBox> yBoxes,
    double extend,
  ) {
    canvas.drawRect(Offset.zero & Size(size.width, 20), Paint()..color = const Color(0xff2a2a2a));

    canvas.save();
    canvas.translate(c.dx, 0);
    paintXCell(canvas, xBoxes, extend);
    canvas.restore();

    canvas.drawRect(Offset.zero & Size(20, size.height), Paint()..color = const Color(0xff2a2a2a));

    canvas.save();
    canvas.translate(0, c.dy);
    paintYCell(canvas, yBoxes, extend);
    canvas.restore();
  }

  void drawGrid(
    Canvas canvas,
    Size size,
    Offset c,
    List<ScaleBox> xBoxes,
    List<ScaleBox> yBoxes,
    double extend,
  ) {
    canvas.save();
    canvas.translate(c.dx, 0);
    paintXGrid(canvas, xBoxes, extend, size.height);
    canvas.restore();

    canvas.save();
    canvas.translate(0, c.dy);
    paintYGrid(canvas, yBoxes, extend, size.width);
    canvas.restore();
  }

  void drawArea(Canvas canvas, Area area, Axis axis, double side) {}

  void drawX(Canvas canvas, Size size, Area area) {}

  // void drawY(Canvas canvas, Size size) {
  //   canvas.drawRect(Offset.zero & Size(20, size.height), Paint()..color = const Color(0xff2a2a2a));
  //
  //   double side = 40;
  //   double scaleWidth = 20;
  //   Area area = Area(0, size.width);
  //   // 使用矩阵变换点
  //   double s = value.tansform.getMaxScaleOnAxis();
  //   double c = value.tansform.getTranslation().y;
  //
  //   Area area2 = scaleArea(area, c, s, c);
  //   //
  //   // double a = m4.transform3(Vector3(area.a-size.width /2, 0, 0.0)).x;
  //   // double b = m4.transform3(Vector3(area.b-size.width /2, 0, 0.0)).x;
  //   // Area area2 = Area(a, b);
  //
  //   // Area area2 = scaleArea(area, c, s);
  //
  //   List<ScaleBox> boxes = [];
  //
  //   int start = (area2.a) ~/ side - 1;
  //   int end = (area2.b) ~/ side + 1;
  //
  //   for (int i = start; i < end; i++) {
  //     boxes.add(ScaleBox(i, side * s, Axis.vertical));
  //   }
  //
  //   canvas.save();
  //   canvas.translate(0, c);
  //   paintYCell(canvas, boxes, scaleWidth);
  //   canvas.restore();
  // }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void paintXCell(Canvas canvas, List<ScaleBox> boxes, double height) {
    Path path = Path();
    for (int i = 0; i < boxes.length; i++) {
      ScaleBox box = boxes[i];
      path
        ..moveTo(box.value * box.width, 0)
        ..relativeLineTo(0, height);
      box.paintText(_textPainter, canvas, height);
    }
    canvas.drawPath(path, _storkPaint);
  }

  void paintYCell(Canvas canvas, List<ScaleBox> boxes, double width) {
    Path path = Path();
    for (int i = 0; i < boxes.length; i++) {
      ScaleBox box = boxes[i];
      path
        ..moveTo(0, box.value * box.width)
        ..relativeLineTo(width, 0);
      box.paintText(_textPainter, canvas, width);
    }
    canvas.drawPath(path, _storkPaint);
  }

  void paintXGrid(Canvas canvas, List<ScaleBox> boxes, double height, double windowHeight) {
    Path gridPath = Path();
    for (int i = 0; i < boxes.length; i++) {
      ScaleBox box = boxes[i];
      gridPath
        ..moveTo(box.value * box.width, height)
        ..relativeLineTo(0, windowHeight);

      box.paintText(_textPainter, canvas, height);
    }
    canvas.drawPath(gridPath, _gridPaint);
  }

  void paintYGrid(Canvas canvas, List<ScaleBox> boxes, double width, double windowWidth) {
    Path gridPath = Path();
    for (int i = 0; i < boxes.length; i++) {
      ScaleBox box = boxes[i];
      gridPath
        ..moveTo(width, box.value * box.width)
        ..relativeLineTo(windowWidth, 0);
      box.paintText(_textPainter, canvas, width);
    }
    canvas.drawPath(gridPath, _gridPaint);
  }
}

class AxisPainter {
  final Size size;

  AxisPainter(this.size);

  void paint(Canvas canvas, TextPainter painter, Offset offset) {
    _drawText(canvas, painter);
    drawAxis(canvas, offset);
  }

  void drawAxis(Canvas canvas, Offset offset) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.cyanAccent;

    canvas.drawLine(Offset(offset.dx, 0), Offset(offset.dx, size.height), paint);
    canvas.drawLine(Offset(0, offset.dy), Offset(size.width, offset.dy), paint);
  }

  void _drawText(Canvas canvas, TextPainter painter) {
    Paint paint = Paint()..style = PaintingStyle.stroke;
    paint.color = const Color(0xffa0a0a0);
    canvas.drawRect(const Rect.fromLTWH(0, 0, 20, 20), Paint()..color = Colors.black);
    canvas.drawLine(Offset.zero, const Offset(20, 20), paint);
    paint.color = const Color(0xff2a2a2a);
    canvas.drawLine(const Offset(0, 20), const Offset(20, 20), paint);
    canvas.drawLine(const Offset(20, 0), const Offset(20, 20), paint);

    const TextStyle style = TextStyle(fontSize: 10, height: 1, color: Color(0xffa0a0a0));
    painter.text = const TextSpan(text: 'x', style: style);
    painter.layout();
    painter.paint(canvas, Offset(20 - painter.width - 4, 2));

    painter.text = const TextSpan(text: 'y', style: style);
    painter.layout();
    painter.paint(canvas, Offset(4, 20 - painter.height - 2));
  }
}
