// Spawns the bubbles
import 'dart:math';

import 'package:big_fish/components/bubble.dart';
import 'package:big_fish/components/jellyfish.dart';
import 'package:big_fish/game.dart';
import 'package:big_fish/utils/knows_game_size.dart';
import 'package:flame/components.dart';

class JellyFishSpawner extends BaseComponent
    with KnowsGameSize, HasGameRef<BigFishGame> {
  late Timer _timer;
  SpriteAnimation anim;
  Random rng = Random();

  JellyFishSpawner({required this.anim}) : super() {
    _timer = Timer(2, callback: _spawnJellyFish, repeat: true);
  }

  void _spawnJellyFish() {
    Vector2 initialSize = Vector2.all(32);
    Vector2 position = Vector2(gameRef.size.x * 1.4 * rng.nextDouble(), -100);

    //position.clamp(Vector2.zero() + initialSize / 2, gameSize - initialSize / 2);

    JellyFish jelly =
        JellyFish(anim: anim, position: position, size: initialSize);

    jelly.anchor = Anchor.center;

    gameRef.add(jelly);
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
  }
}
