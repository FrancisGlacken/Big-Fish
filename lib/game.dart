import 'dart:math';
import 'package:big_fish/components/bubble_spawner.dart';
import 'package:big_fish/components/command.dart';
import 'package:big_fish/components/jellyfish_spawner.dart';
import 'package:big_fish/components/krill_spawner.dart';
import 'package:big_fish/components/player.dart';
import 'package:big_fish/components/trout.dart';
import 'package:big_fish/components/trout_spawner.dart';
import 'package:big_fish/components/turtle_spawner.dart';
import 'package:big_fish/utils/globals.dart';
import 'package:big_fish/utils/knows_game_size.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/keyboard.dart';
import 'package:flame/parallax.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/raw_keyboard.dart';

class BigFishGame extends BaseGame with KeyboardEvents, HasCollidables {
  // late Image troutImage;
  // late SpriteAnimationComponent trout;
  late final TroutSpawner troutSpawner;
  late final BubbleSpawner bubbleSpawner;
  late final JellyFishSpawner jellyFishSpawner;
  late final KrillSpawner krillSpawner;
  late final TurtleSpawner turtleSpawner;
  late final ScreenCollidable screenCollidable;

  late TextComponent _playerScore;
  late TextComponent _playerHealth;
  late PlayerTadpole _playerTadpole;

  final _commandList = List<Command>.empty(growable: true);
  final _addLaterCommandList = List<Command>.empty(growable: true);

  BigFishGame();

  final _layersMeta = {'new_ocean.png': .1};

  @override
  Future<void> onLoad() async {
    //troutImage = await images.load('trout.png');

    final layers = _layersMeta.entries.map(
      (e) => loadParallaxLayer(
        ParallaxImageData(e.key),
        velocityMultiplier: Vector2(e.value, 1.0),
      ),
    );
    final parallax = ParallaxComponent.fromParallax(
      Parallax(
        await Future.wait(layers),
        baseVelocity: Vector2(30, 0),
      ),
    );

    final _bubbleSprite = await Sprite.load('bubble.png');

    final _playerAnim = await loadSpriteAnimation(
      'lilbigfish.png',
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2.all(32),
        stepTime: 0.15,
      ),
    );

    final _jellyFishAnim = await loadSpriteAnimation(
      'jellyfish.png',
      SpriteAnimationData.sequenced(
        amount: 10,
        textureSize: Vector2.all(16),
        stepTime: .8,
      ),
    );

    final _krillAnim = await loadSpriteAnimation(
      'krill.png',
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(64, 32),
        stepTime: 0.5,
      ),
    );

    final _troutAnim = await loadSpriteAnimation(
      'trout.png',
      SpriteAnimationData.sequenced(
        amount: 15,
        textureSize: Vector2.all(100),
        stepTime: 0.6,
      ),
    );

    final _turtleAnim = await loadSpriteAnimation(
      'turtle.png',
      SpriteAnimationData.sequenced(
        amount: 7,
        textureSize: Vector2(100, 40),
        stepTime: 1,
      ),
    );

    _playerTadpole = PlayerTadpole(
        anim: _playerAnim,
        size: Vector2.all(32),
        position: Vector2(size.x / 2, size.y / 2));

    _playerTadpole.anchor = Anchor.center;

    add(parallax);
    add(_playerTadpole);
    add(screenCollidable = ScreenCollidable());
    add(troutSpawner = TroutSpawner(anim: _troutAnim));
    add(bubbleSpawner = BubbleSpawner(sprite: _bubbleSprite));
    add(jellyFishSpawner = JellyFishSpawner(anim: _jellyFishAnim));
    add(krillSpawner = KrillSpawner(anim: _krillAnim));
    add(turtleSpawner = TurtleSpawner(anim: _turtleAnim));

    _playerScore = TextComponent(
      'Score: 0',
      position: Vector2(10, 10),
      textRenderer: TextPaint(
        config: TextPaintConfig(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'BungeeInline',
        ),
      ),
    );

    add(_playerScore);

    //playerHealth
  }

  // WASD Keys Control
  @override
  void onKeyEvent(RawKeyEvent e) {
    final isKeyDown = e is RawKeyDownEvent;
    if (e.data.keyLabel == 'a') {
      lilBigFishVelocity.x = isKeyDown ? -1 : 0;
    } else if (e.data.keyLabel == 'd') {
      lilBigFishVelocity.x = isKeyDown ? 1 : 0;
    } else if (e.data.keyLabel == 'w') {
      lilBigFishVelocity.y = isKeyDown ? -1 : 0;
    } else if (e.data.keyLabel == 's') {
      lilBigFishVelocity.y = isKeyDown ? 1 : 0;
    }
  }

  @override
  void prepare(Component c) {
    super.prepare(c);

    if (c is KnowsGameSize) {
      c.onGameResize(this.size);
    }
  }

  @override
  void onResize(Vector2 canvasSize) {
//    canvasSize = Vector2(720, 480);
    super.onResize(canvasSize);

    this.components.whereType<KnowsGameSize>().forEach((component) {
      component.onResize(this.size);
    });
  }

  @override
  void update(double dt) {
    super.update(dt);

    _commandList.forEach((command) {
      components.forEach((component) {
        command.run(component);
      });
    });

    _commandList.clear();
    _commandList.addAll(_addLaterCommandList);
    _addLaterCommandList.clear();

    _playerScore.text = 'Score: ${_playerTadpole.score}';
  }

  void addCommand(Command command) {
    _addLaterCommandList.add(command);
  }
}

//unused
class YellowCube extends SpriteComponent {
  YellowCube(position);

  @override
  Future<void> onLoad() async {
    final sprite = await Sprite.load('cube.png');
    final size = Vector2.all(128.0);
    this.sprite = sprite;
    this.size = size;
  }
}
