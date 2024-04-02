import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flame_ext/flame_ext.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../res/extra_images.dart';
import 'config/audio_manager/audio_manager.dart';
import 'config/audio_manager/sound_effect.dart';
import 'config/game_config.dart';
import 'heroes/ball.dart';

import 'heroes/bricks.dart';
import 'heroes/bullet.dart';
import 'heroes/playground.dart';
import 'heroes/paddle.dart';
import 'heroes/game_top_bar/game_top_bar.dart';
import 'heroes/prop/prop.dart';
import 'heroes/prop/prop_display.dart';
import 'heroes/prop/prop_manager.dart';
import 'model/level.dart';

const Size kViewPort = Size(64 * 9, 64 * 9 * 2400 / 1080);

enum GameStatus { playing, ready, gameOver }

class BricksGame extends FlameGame<PlayWorld>
    with KeyboardEvents, HasCollisionDetection {
  BricksGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: kViewPort.width,
            height: kViewPort.height,
          ),
          world: PlayWorld(),
        );

  TextureLoader loader = TextureLoader();

  GameStatus status = GameStatus.ready;

  late AudioManager am;
  late SharedPreferences sp;

  late GameConfigManager configManager;

  GameConfig get config => configManager.config;

  late final Image bgImage;

  // int blueCrystal = 10;

  int _levelNum = 1;

  int get levelCount => _levels.length;

  final Random _random = Random();

  Random get random => _random;

  // value: 概率 0~1
  bool probability(double value) {
    double rad = random.nextDouble();
    return rad < value;
  }

  set levelNum(int level) {
    if (_levelNum != level) {
      _levelNum = level.clamp(1, _levels.length);
      // 设置关卡时，重置砖块管理器
      restart();
    }
  }

  void nextLever() {
    levelNum = _levelNum + 1;
  }

  void restart() {
    world = PlayWorld();
    status = GameStatus.ready;
  }

  List<Level> _levels = [];

  Level get level => _levels[_levelNum - 1];

  Future<void> loadLevels() async {
    String path = 'assets/data/bricks_levels.json';
    String data = await rootBundle.loadString(path);
    List<dynamic> list = json.decode(data) as List;
    _levels = list.map(Level.fromMap).toList();
  }

  @override
  FutureOr<void> onLoad() async {
    sp = await SharedPreferences.getInstance();
    configManager = GameConfigManager(sp);
    configManager.loadConfig(sp);
    _levelNum = configManager.config.maxUnLockLevel;
    am = AudioManager(configManager);
    am.startBgm();
    await loadLevels();
    await loader.load(
      'assets/images/break_bricks/break_bricks.json',
      'break_bricks/break_bricks.png',
      extra: extraImages,
    );
    bgImage = await Flame.images.load('break_bricks/bg_gallery.png');
    camera.viewfinder.anchor = Anchor.topLeft;
  }

  @override
  Color backgroundColor() => const Color(0xffC5CDDA);

  final double moveStep = 40;

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (status == GameStatus.ready) KeyEventResult.handled;
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowLeft:
          world.paddle.moveBy(-moveStep);
        case LogicalKeyboardKey.arrowRight:
          world.paddle.moveBy(moveStep);
          world.paddle.moveBy(moveStep);
      }
    }
    return KeyEventResult.handled;
  }
}

class PlayWorld extends World
    with
        HasGameRef<BricksGame>,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  Paddle paddle = Paddle();

  late BrickManager brickManager = BrickManager();
  BulletManager bulletManager = BulletManager();
  late PropManager propManager = PropManager();

  GameTopBar titleBar = GameTopBar();
  int _life = 3;

  void gameOver() {
    game.status = GameStatus.gameOver;
    game.am.play(SoundEffect.uiClose);
    game.overlays.add('GameOverMenu');
  }

  void checkSuccess() {
    if (brickManager.children.isEmpty) {
      game.am.play(SoundEffect.uiClose);
      game.overlays.add('GameSuccessMenu');

      game.configManager.unlockNextLevel();
      game.configManager.addBlueCrystal();
      // game.blueCrystal += 1;
      game.status = GameStatus.gameOver;
    }
  }

  void addLife() {
    _life += 1;
    titleBar.updateLifeCount(_life);
  }

  /// 是否处于 无敌状态
  bool get isInvincible =>
      displays.where((e) => e.prop == Prop.invincible).isNotEmpty;

  /// 是否处于 射击状态
  bool get isShoot =>
      displays.where((e) => e.prop == Prop.shoot).isNotEmpty;

  List<PropDisplay> get displays => children.whereType<PropDisplay>().toList();



  void addPropDisplay(Prop pro) {
    /// 没有道具展示时，添加 PropDisplay
    if (displays.isEmpty) {
      PropDisplay display = PropDisplay(pro);
      display.position = Vector2(360, 86);
      add(display);
      return;
    }

    /// 表示已经存在展示的道具
    List<PropDisplay> targets = displays.where((e) => e.prop == pro).toList();
    if (targets.isNotEmpty) {
      /// 已存当前道具效力, + 生命时间
      displays.first.addOne();
      return;
    } else {
      /// 有没有，则在之后加一个
      PropDisplay display = PropDisplay(pro);
      display.position =
          displays.last.position + Vector2(displays.last.width + 8, 0);
      add(display);
    }
  }

  void died() {
    _life -= 1;
    titleBar.updateLifeCount(_life);
    game.status = GameStatus.ready;

    if (_life == 0) {
      gameOver();
    } else {
      addBall();
    }
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    add(Playground());
    add(paddle);
    addBall();
    add(brickManager);
    add(propManager);
    add(bulletManager);
    add(titleBar);
    initPosition();
    // toggleHitBoxTree();
    // add(FpsTextComponent()..y=kViewPort.height-42..x=12);
  }

  void initPosition() {
    brickManager.y = titleBar.height;
    propManager.y = titleBar.height;
  }

  @override
  void onTapDown(TapDownEvent event) {
    play();
  }

  void play() {
    if (game.status == GameStatus.ready) {
      List<Ball> balls = children.whereType<Ball>().toList();
      if (balls.isNotEmpty) {
        balls.first.run();
        game.status = GameStatus.playing;
      }
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    double dx = event.localDelta.x;
    double max = kViewPort.width - paddle.width/2;
    paddle.x = (paddle.x + dx).clamp(paddle.width/2, max);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    play();
  }

  void addBall({bool autoPlay = false}) {
    Ball ball = Ball();
    ball.anchor = Anchor.bottomCenter;
    add(ball);
    ball.position = paddle.center - Vector2(0, paddle.height / 2 + 4);
    if (autoPlay) {
      ball.run();
    }
  }
}
