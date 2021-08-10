import 'dart:math';
import 'package:big_fish/components/command.dart';
import 'package:big_fish/components/trout_spawner.dart';
import 'package:big_fish/game.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class Trout extends SpriteAnimationComponent
    with HasGameRef<BigFishGame>, Hitbox, Collidable {
  num speedModifier = 80;
  Random rng = new Random();

  Trout({
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

  final command = Command<TroutSpawner>(action: (troutSpawner) {
    troutSpawner.removeOneTroutFromPopulation();
  });

  @override
  void update(double dt) {
    position.x = position.x + 1;

    if (x < -100 ||
        x > gameRef.viewport.canvasSize.x + 100 ||
        y < -100 ||
        y > gameRef.size.y + 100) {
      gameRef.addCommand(command);
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
    if (other is ScreenCollidable) {}
    // else if (other is YourOtherCollidable) {
    //   ...
    // }
  }
}
