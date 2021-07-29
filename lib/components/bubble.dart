// Non-kinetic bubble
import 'dart:math';

import 'package:big_fish/utils/knows_game_size.dart';
import 'package:flame/components.dart';

class Bubble extends SpriteComponent with KnowsGameSize, Hitbox, Collidable {
  Random rng = new Random();
  Bubble({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(sprite: sprite, position: position, size: size);

  @override
  Future<void>? onLoad() async {}

  @override
  void update(double dt) {
    super.update(dt);
    position.y = position.y - .2;

    if (this.position.y < 0) {
      remove();
    }
  }

  @override
  void onRemove() {
    super.onRemove();

    print('Popping ${this.toString()}');
  }
}
