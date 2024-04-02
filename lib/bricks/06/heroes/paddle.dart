import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:toly_game/bricks/06/heroes/prop/prop.dart';

import '../bricks_game.dart';

class Paddle extends SpriteComponent with HasGameRef<BricksGame> , CollisionCallbacks {

  void expand(){
    sprite = game.loader['Paddle_A_Blue_192x28.png'];
  }

  void expandEnd(){
    sprite = game.loader['Paddle_A_Blue_96x28.png'];
  }

  @override
  FutureOr<void> onLoad() {
    sprite = game.loader['Paddle_A_Blue_96x28.png'];
    add(RectangleHitbox());
    anchor =Anchor.center;
    y = kViewPort.height - 160;
    x = kViewPort.width / 2;
    return super.onLoad();
  }

  void moveBy(double dx) {
    game.world.play();
    double newX = position.x + dx;
    if (newX < width/2) {
      x = width/2;
      return;
    }
    if (newX > game.size.x - width/2) {
      x = game.size.x - width/2;
      return;
    }
    add(MoveToEffect(
      Vector2(newX, position.y),
      EffectController(duration: 0.1),
    ));
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if(other is PropComponent){
      onGetProp(other.prop);
      other.removeFromParent();
    }
  }

  void onGetProp(Prop prop){
    if(prop==Prop.addBall){
      game.world.addBall(autoPlay: true);
      return;
    }
    if(prop==Prop.life){
      game.world.addLife();
      return;
    }
    if(prop==Prop.shoot){
      game.world.bulletManager.startShoot();
    }
    if(prop==Prop.expand){
      expand();
    }
    game.world.addPropDisplay(prop);
  }
}
