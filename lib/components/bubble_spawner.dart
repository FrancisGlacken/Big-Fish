// Spawns the bubbles
import 'dart:math';

import 'package:big_fish/components/bubble.dart';
import 'package:big_fish/game.dart';
import 'package:big_fish/utils/knows_game_size.dart';
import 'package:flame/components.dart';

class BubbleSpawner extends BaseComponent
    with KnowsGameSize, HasGameRef<BigFishGame> {
  late Timer _timer;
  Sprite sprite;
  Random rng = Random();

  BubbleSpawner({required this.sprite}) : super() {
    _timer = Timer(1, callback: _spawnBubble, repeat: true);
  }

  void _spawnBubble() {
    Vector2 initialSize = Vector2.all(16);
    Vector2 position = Vector2(
        gameRef.viewport.canvasSize.x * rng.nextDouble(), gameRef.size.y);

    //position.clamp(Vector2.zero() + initialSize / 2, gameSize - initialSize / 2);

    Bubble bubble =
        Bubble(sprite: sprite, position: position, size: initialSize);

    bubble.anchor = Anchor.center;

    gameRef.add(bubble);
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
