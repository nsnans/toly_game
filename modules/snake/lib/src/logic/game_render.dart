import 'dart:collection';
import 'dart:math';

import 'package:snake/src/model/configable.dart';
import 'package:snake/src/logic/game_state_mixin.dart';

import 'game_ctrl_mixin.dart';
import '../model/foods.dart';
import '../model/game_status.dart';
import '../model/snake.dart';

mixin WorldRender on Configable, GameStateMixin {
  void onSnakeChange();

  void onDied();

  void onFoodChange(FoodNode food);

  void onEatFood(FoodNode food);

  int _timeRecord = 0;

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
    Point<int> oldHead = snakeList.first.position;
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
    int foodIndex = foodList.indexWhere((e) => e.position == newHead);
    updateSnakeAttr();
    if (foodIndex != -1) {
      FoodNode food = foodList.removeAt(foodIndex);
      snakeList.addFirst(SnakeNode(position: newHead));
      snakeList.last.color = food.color;
      onEatFood(food);
      createFoods(1);
    } else {
      snakeList.addFirst(SnakeNode(position: newHead));
      snakeList.removeLast();
    }
  }

  /// 将后元素的属性，赋值给前一元素
  void updateSnakeAttr() {
    List<SnakeNode> snake = snakeList.toList();
    for (int i = 0; i < snake.length - 1; i++) {
      snake[i].color = snake[i + 1].color;
    }
  }

  bool _checkAlive(Point<int> head) {
    bool selfLoop = snakeList.skip(1).where((e) => e.position == head).isNotEmpty;
    bool outRange = head.x < 0 || head.y < 0 || head.x >= column || head.y >= row;
    return !(outRange || selfLoop);
  }

  @override
  void reset() {
    super.reset();
    createSnake();
    onSnakeChange();
    foodList.clear();
    createFoods(3);
  }

  void createSnake() {
    snakeList.clear();
    int initCount = 3;
    int initX = column ~/ 2;
    int initY =  row ~/ 2;
    for (int i = 0; i < initCount; i++) {
      Point<int> position = Point<int>(initX, initY+ i);
      snakeList.add(SnakeNode(position: position));
    }
  }

  void createFoods(int count) {
    Random random = Random();
    Set<Point> exist = {...snakeList.map((e) => e.position), ...foodList.map((e) => e.position)};
    Set<Point<int>> foodPositionPool = {};
    for (int i = 0; i < column; i++) {
      for (int j = 0; j < row; j++) {
        foodPositionPool.add((Point(i, j)));
      }
    }
    foodPositionPool = foodPositionPool.difference(exist);
    for (int i = 0; i < count; i++) {
      Point<int> position = foodPositionPool.toList()[random.nextInt(foodPositionPool.length)];
      foodList.add(
        FoodNode(
            color: kColorSupport[random.nextInt(kColorSupport.length)],
            position: position,
            score: 20 + random.nextInt(40)),
      );
      foodPositionPool.remove(position);
    }
    onFoodChange(foodList.first);
  }
}
