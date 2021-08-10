// Spawns the bubbles
import 'dart:math';

import 'package:big_fish/components/krill.dart';
import 'package:big_fish/components/trout.dart';
import 'package:big_fish/game.dart';
import 'package:big_fish/utils/knows_game_size.dart';
import 'package:flame/components.dart';

class TroutSpawner extends BaseComponent
    with KnowsGameSize, HasGameRef<BigFishGame> {
  late Timer _timer;
  SpriteAnimation anim;
  Random _rng = Random();
  int _troutLimit = 30;
  int _troutPopulation = 0;

  TroutSpawner({required this.anim}) : super() {
    _timer = Timer(2, callback: _spawnTrout, repeat: true);
  }

  void _spawnTrout() {
    Vector2 initialSize = Vector2(80, 40);
    Vector2 position = Vector2(0, gameRef.size.y * _rng.nextDouble());

    //position.clamp(Vector2.zero() + initialSize / 2, gameSize - initialSize / 2);
    Trout trout = Trout(anim: anim, position: position, size: initialSize);

    trout.anchor = Anchor.center;
    if (_troutPopulation < _troutLimit) {
      _troutPopulation += 1;
      gameRef.add(trout);
    }
  }

  void removeOneTroutFromPopulation() {
    _troutPopulation -= 1;
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
