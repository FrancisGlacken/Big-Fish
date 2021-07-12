import 'dart:math';
import 'dart:ui';

import 'package:big_fish/components/player.dart';
import 'package:big_fish/utils/globals.dart';
import 'package:big_fish/utils/knows_game_size.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/keyboard.dart';
import 'package:flame/parallax.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/src/services/raw_keyboard.dart';

class BigFishGame extends BaseGame with KeyboardEvents, HasCollidables {
  // late Image troutImage;
  // late SpriteAnimationComponent trout;
  late final SpriteComponent bubble;
  late final TroutSpawner troutSpawner;
  late final BubbleSpawner bubbleSpawner;
  late final JellyFishSpawner jellyFishSpawner;
  late final KrillSpawner krillSpawner;
  late final ScreenCollidable screenCollidable;

  BigFishGame();

  final _layersMeta = {
    'new_ocean.png': .1
    //'ocean_1.png': .1,
    //'ocean_2.png': 0.00001,
  };

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

    final playerAnim = await loadSpriteAnimation(
      'lilbigfish.png',
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2.all(32),
        stepTime: 0.15,
      ),
    );

    final playerTadpole = PlayerTadpole(
        anim: playerAnim,
        size: Vector2.all(32),
        position: Vector2(size.x / 2, size.y / 2));

    playerTadpole.anchor = Anchor.center;

    add(parallax);
    add(playerTadpole);
    add(screenCollidable = ScreenCollidable());
    add(troutSpawner = TroutSpawner());
    add(bubbleSpawner = BubbleSpawner());
    add(jellyFishSpawner = JellyFishSpawner());
    add(krillSpawner = KrillSpawner());
  }

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
}

// Non-kinetic bubble
class Bubble extends SpriteComponent
    with HasGameRef<BigFishGame>, Hitbox, Collidable {
  Random rng = new Random();
  Bubble();

  @override
  Future<void>? onLoad() async {
    final sprite = await Sprite.load('bubble.png');
    this.sprite = sprite;
    this.size = Vector2.all(16);
    this.position = Vector2(
        gameRef.viewport.canvasSize.x * rng.nextDouble(), gameRef.size.y);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y = position.y - .2;
  }
}

// Spawns the bubbles
class BubbleSpawner extends Component with HasGameRef<BigFishGame> {
  late Timer timer;

  BubbleSpawner() {
    timer = Timer(1, repeat: true, callback: () {
      gameRef.add(Bubble());
    });
    timer.start();
  }

  @override
  void update(double t) {
    timer.update(t);
  }
}

// class LilBigFishOld extends SpriteAnimationComponent
//     with HasGameRef<BigFishGame>, Hitbox, Collidable {
//   final double speed = 60;
//   var fishSize = Vector2.all(32);

//   Random rng = new Random();

//   @override
//   Future<void>? onLoad() async {

//     final shape = HitboxPolygon(
//         [Vector2(0, 1), Vector2(-1, 0), Vector2(0, -1), Vector2(1, 0)]);

//     addShape(shape);
//   }

//   @override
//   void onCollision(Set<Vector2> points, Collidable other) {
//     if (other is ScreenCollidable) {
//       //lilBigFishVelocity = Vector2.all(0);
//     } else if (other is Trout) {
//       this.remove();
//     } else if (other is JellyFish) {
//       this.remove();
//     } else if (other is Krill) {
//       fishSize += Vector2.all(1);
//       this.size = fishSize;
//     }
//   }

//   @override
//   void onCollisionEnd(Collidable other) {
//     // if (other is CollidableScreen) {
//     //   ...
//     // } else if (other is YourOtherCollidable) {
//     //   ...
//     // }
//   }

//   @override
//   void update(double dt) {
//     position.x = position.x + lilBigFishVelocity.x * speed * dt;
//     position.y = position.y + lilBigFishVelocity.y * speed * dt;
//     super.update(dt);
//   }
// }

class Trout extends SpriteAnimationComponent
    with HasGameRef<BigFishGame>, Hitbox, Collidable {
  Random rng = new Random();

  @override
  Future<void>? onLoad() async {
    this.size = Vector2.all(100);
    this.animation = await gameRef.loadSpriteAnimation(
      'trout.png',
      SpriteAnimationData.sequenced(
        amount: 15,
        textureSize: Vector2.all(100),
        stepTime: 0.15,
      ),
    );
    this.position = Vector2(-100, gameRef.size.y * rng.nextDouble());

    final shape = HitboxPolygon(
        [Vector2(0, 1), Vector2(-1, 0), Vector2(0, -1), Vector2(1, 0)]);

    addShape(shape);
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

  @override
  void update(double dt) {
    position.x = position.x + 1;

    if (x < -100 ||
        x > gameRef.viewport.canvasSize.x + 100 ||
        y < -100 ||
        y > gameRef.size.y + 100) {
      this.remove();
    }

    super.update(dt);
  }
}

class TroutSpawner extends Component with HasGameRef<BigFishGame> {
  late Timer timer;

  TroutSpawner() {
    timer = Timer(8, repeat: true, callback: () {
      gameRef.add(Trout());
    });
    timer.start();
  }

  @override
  void update(double t) {
    timer.update(t);
  }
}

class JellyFish extends SpriteAnimationComponent
    with HasGameRef<BigFishGame>, Hitbox, Collidable {
  num speedModifier = 80;
  Random rng = new Random();

  @override
  Future<void>? onLoad() async {
    this.size = Vector2.all(32);
    this.animation = await gameRef.loadSpriteAnimation(
      'jellyfish.png',
      SpriteAnimationData.sequenced(
        amount: 10,
        textureSize: Vector2.all(16),
        stepTime: 0.15,
      ),
    );
    this.position = Vector2(gameRef.size.x * 1.4 * rng.nextDouble(), -100);

    final shape = HitboxPolygon(
        [Vector2(0, 1), Vector2(-1, 0), Vector2(0, -1), Vector2(1, 0)]);

    addShape(shape);
  }

  @override
  void update(double dt) {
    x -= speedModifier * dt;
    speedModifier -= .5;
    if (speedModifier <= 4) speedModifier = 80;
    y = y + speedModifier * dt;

    if (x < -100 ||
        x > gameRef.size.x + 500 ||
        y < -500 ||
        y > gameRef.size.y + 100) {
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
    // if (other is CollidableScreen) {
    //   ...
    // } else if (other is YourOtherCollidable) {
    //   ...
    // }
  }
}

class JellyFishSpawner extends Component with HasGameRef<BigFishGame> {
  late Timer timer;

  JellyFishSpawner() {
    timer = Timer(2, repeat: true, callback: () {
      gameRef.add(JellyFish());
    });
    timer.start();
  }

  @override
  void update(double t) {
    timer.update(t);
  }
}

class Krill extends SpriteAnimationComponent
    with HasGameRef<BigFishGame>, Hitbox, Collidable {
  num speedModifier = 80;
  Random rng = new Random();

  @override
  Future<void>? onLoad() async {
    this.size = Vector2.all(16);
    this.animation = await gameRef.loadSpriteAnimation(
      'Krill.png',
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(64, 32),
        stepTime: 0.5,
      ),
    );
    this.position = Vector2(gameRef.viewport.canvasSize.x + 100,
        gameRef.viewport.canvasSize.y * rng.nextDouble());

    final shape = HitboxPolygon(
        [Vector2(0, 1), Vector2(-1, 0), Vector2(0, -1), Vector2(1, 0)]);

    addShape(shape);
  }

  @override
  void update(double dt) {
    position.x -= 1;

    if (x < -100 ||
        x > gameRef.size.x + 500 ||
        y < -500 ||
        y > gameRef.size.y + 100) {
      this.remove();
    }
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    if (other is PlayerTadpole) {
      this.remove();
    }
    // else if (other is YourOtherCollidable) {
    //   ...
    // }
  }

  @override
  void onCollisionEnd(Collidable other) {
    // if (other is CollidableScreen) {
    //   ...
    // } else if (other is YourOtherCollidable) {
    //   ...
    // }
  }
}

class KrillSpawner extends Component with HasGameRef<BigFishGame> {
  late Timer timer;

  KrillSpawner() {
    timer = Timer(.8, repeat: true, callback: () {
      gameRef.add(Krill());
    });
    timer.start();
  }

  @override
  void update(double t) {
    timer.update(t);
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
