import 'dart:math';

import 'package:big_fish/components/jellyfish.dart';
import 'package:big_fish/components/krill.dart';
import 'package:big_fish/components/trout.dart';
import 'package:big_fish/game.dart';
import 'package:big_fish/utils/globals.dart';
import 'package:big_fish/utils/knows_game_size.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class PlayerTadpole extends SpriteAnimationComponent
    with KnowsGameSize, HasGameRef<BigFishGame>, Hitbox, Collidable {
  final double speed = 80;
  var fishSize = Vector2.all(32);
  Random rng = new Random();

  int _score = 0;
  int get score => _score;

  Vector2 _moveDirection = Vector2.zero();

  PlayerTadpole({
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
  void onCollision(Set<Vector2> points, Collidable other) {
    if (other is ScreenCollidable) {
      //lilBigFishVelocity = Vector2.all(0);
    } else if (other is Trout) {
      this.remove();
    } else if (other is JellyFish) {
      this.remove();
    } else if (other is Krill) {
      fishSize += Vector2.all(10);
      this.size = fishSize;
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    // if (other is CollidableScreen) {
    //   ...
    // } else if (other is YourOtherCollidable) {
    //   ...
    // }
  }

  @override
  void update(double dt) {
    super.update(dt);
    this.position.x = position.x + lilBigFishVelocity.x * speed * dt;
    this.position.y = position.y + lilBigFishVelocity.y * speed * dt;

    //this.position += _moveDirection.normalized() * speed * dt;

    this.position.clamp(
          Vector2.zero() + this.size / 2,
          gameRef.size - this.size / 2,
        );
  }

  void setMoveDirection(Vector2 newMoveDirection) {
    _moveDirection = newMoveDirection;
  }

  void addToScore(int points) {
    _score += points;
  }
}
