import 'dart:math';

import 'package:big_fish/game.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class JellyFish extends SpriteAnimationComponent
    with HasGameRef<BigFishGame>, Hitbox, Collidable {
  num speedModifier = 80;
  Random rng = new Random();

  JellyFish({
    SpriteAnimation? anim,
    Vector2? position,
    Vector2? size,
  }) : super(animation: anim, position: position, size: size);

  @override
  Future<void>? onLoad() async {
    final shape = HitboxPolygon(
        [Vector2(0, 1), Vector2(-1, 0), Vector2(0, -1), Vector2(1, 0)]);

    addShape(shape);
  }

  @override
  void update(double dt) {
    x -= speedModifier * dt;
    speedModifier -= .5;
    if (speedModifier <= 4) speedModifier = 80;
    y = y + speedModifier * dt;

    if (x < -100 ||
        x > gameRef.size.x + 500 ||
        y < -500 ||
        y > gameRef.size.y + 100) {
      this.remove();
    }
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    // if (other is CollidableScreen) {
    //   ...
    // } else if (other is YourOtherCollidable) {
    //   ...
    // }
  }

  @override
  void onCollisionEnd(Collidable other) {
    // if (other is CollidableScreen) {
    //   ...
    // } else if (other is YourOtherCollidable) {
    //   ...
    // }
  }
}
