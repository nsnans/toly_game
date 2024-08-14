import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:snake/src/logic/configable.dart';
import 'package:snake/src/logic/speed.dart';

import '../game/mixin/direction_mixin.dart';

enum GameStatus { ready, playing, paused, died }

mixin WorldRender on Configable {
  Queue<Point<int>> snakeList =
      Queue.of([const Point(10, 8), const Point(10, 9), const Point(10, 10)]);
  List<Point<int>> foodList = [const Point(6, 6)];

  int _timeRecord = 0;

  GameStatus status = GameStatus.ready;

  void onSnakeChange();

  void onDied();

  void onFoodChange(Point<int> food);

  void tickRender(Direction direction) {
    if (status != GameStatus.playing) return;
    int cur = DateTime.now().millisecondsSinceEpoch;
    bool timeSkip = cur - _timeRecord < speed.time;
    if (timeSkip) return;
    move(direction);
    onSnakeChange();
    _timeRecord = cur;
  }

  void move(Direction direction) {
    Point<int> oldHead = snakeList.first;
    Point<int> newHead = switch (direction) {
      Direction.up => Point(oldHead.x, oldHead.y - 1),
      Direction.down => Point(oldHead.x, oldHead.y + 1),
      Direction.left => Point(oldHead.x - 1, oldHead.y),
      Direction.right => Point(oldHead.x + 1, oldHead.y),
    };
    if (!_checkAlive(newHead)) {
      onDied();
      return;
    }
    snakeList.addFirst(newHead);
    if (foodList.contains(newHead)) {
      foodList.remove(newHead);
      generateNewFood();
    } else {
      snakeList.removeLast();
    }
  }

  void generateNewFood() {
    Random random = Random();
    Set<Point> exist = {...snakeList, ...snakeList};
    Set<Point<int>> foodPool = {};
    for (int i = 0; i < column; i++) {
      for (int j = 0; j < row; j++) {
        foodPool.add((Point(i, j)));
      }
    }
    foodPool = foodPool.difference(exist);
    Point<int> newFood = foodPool.toList()[random.nextInt(foodPool.length)];
    foodList.add(newFood);
    onFoodChange(newFood);
  }

  bool _checkAlive(Point<int> newHead) {
    if (newHead.x < 0 ||
        newHead.y < 0 ||
        newHead.x >= column ||
        newHead.y >= row ||
        snakeList.skip(1).contains(newHead)) {
      return false;
    }
    return true;
  }
}
