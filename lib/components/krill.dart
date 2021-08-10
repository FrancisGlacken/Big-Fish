import 'dart:math';

import 'package:big_fish/components/command.dart';
import 'package:big_fish/components/player.dart';
import 'package:big_fish/game.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class Krill extends SpriteAnimationComponent
    with HasGameRef<BigFishGame>, Hitbox, Collidable {
  num speedModifier = 80;
  Random rng = new Random();

  Krill({
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
    position.x -= .5;

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
    if (other is PlayerTadpole) {
      this.remove();
      final command = Command<PlayerTadpole>(action: (playerTadpole) {
        playerTadpole.addToScore(1);
      });
      gameRef.addCommand(command);
    }
    // else if (other is YourOtherCollidable) {
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
