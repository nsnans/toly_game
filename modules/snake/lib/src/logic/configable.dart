import 'package:flame/components.dart';
import 'package:snake/src/logic/speed.dart';

mixin Configable {
  int column = 24;
  int row = 14;
  double boxSize = 24;

  Vector2 get gridSize=> Vector2(column * boxSize, row * boxSize);

  Speed _speed = Speed.initial;

  Speed get speed => _speed;
}
