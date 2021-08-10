import 'dart:math';
import 'package:big_fish/game.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class Turtle extends SpriteAnimationComponent
    with HasGameRef<BigFishGame>, Hitbox, Collidable {
  num speedModifier = 80;
  Random rng = new Random();

  Turtle({
    SpriteAnimation? anim,
    Vector2? position,
    Vector2? size,
  }) : super(animation: anim, position: position, size: size);

  @override
  Future<void>? onLoad() async {
    final shape = HitboxCircle(definition: .4);

    //HitboxPolygon([Vector2(0, .8), Vector2(-.8, 0), Vector2(0, -.8), Vector2(.5, 0)]);

    addShape(shape);
  }

  @override
  void update(double dt) {
    position.x = position.x - 1;

    if (x < -100 ||
        x > gameRef.viewport.canvasSize.x + 100 ||
        y < -100 ||
        y > gameRef.size.y + 100) {
      this.remove();
      gameRef.turtleSpawner.removeOneTurtleFromPopulation();
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
