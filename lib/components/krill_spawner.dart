// Spawns the bubbles
import 'dart:math';

import 'package:big_fish/components/krill.dart';
import 'package:big_fish/game.dart';
import 'package:big_fish/utils/knows_game_size.dart';
import 'package:flame/components.dart';

class KrillSpawner extends BaseComponent
    with KnowsGameSize, HasGameRef<BigFishGame> {
  late Timer _timer;
  SpriteAnimation anim;
  Random rng = Random();

  KrillSpawner({required this.anim}) : super() {
    _timer = Timer(2, callback: _spawnKrill, repeat: true);
  }

  void _spawnKrill() {
    Vector2 initialSize = Vector2.all(16);
    Vector2 position = Vector2(gameRef.viewport.canvasSize.x + 100,
        gameRef.viewport.canvasSize.y * rng.nextDouble());

    //position.clamp(Vector2.zero() + initialSize / 2, gameSize - initialSize / 2);

    Krill krill = Krill(anim: anim, position: position, size: initialSize);

    krill.anchor = Anchor.center;

    gameRef.add(krill);
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
