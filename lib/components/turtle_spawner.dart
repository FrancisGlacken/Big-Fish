import 'dart:math';
import 'package:big_fish/components/turtle.dart';
import 'package:big_fish/game.dart';
import 'package:big_fish/utils/knows_game_size.dart';
import 'package:flame/components.dart';

class TurtleSpawner extends BaseComponent
    with KnowsGameSize, HasGameRef<BigFishGame> {
  late Timer _timer;
  SpriteAnimation anim;
  Random rng = Random();
  int _turtleLimit = 1;
  int _turtlePopulation = 0;

  TurtleSpawner({required this.anim}) : super() {
    _timer = Timer(2, callback: _spawnTurtle, repeat: true);
  }

  void _spawnTurtle() {
    Vector2 initialSize = Vector2(100, 40);
    Vector2 position = Vector2(
        gameRef.size.x + initialSize.x, gameRef.size.y * rng.nextDouble());

    //position.clamp(Vector2.zero() + initialSize / 2, gameSize - initialSize / 2);

    Turtle turtle = Turtle(anim: anim, position: position, size: initialSize);

    turtle.anchor = Anchor.center;

    if (_turtlePopulation < _turtleLimit) {
      _turtlePopulation += 1;
      gameRef.add(turtle);
    }
    turtle.size = turtle.size * 2;
  }

  void removeOneTurtleFromPopulation() {
    _turtlePopulation -= _turtlePopulation;
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
