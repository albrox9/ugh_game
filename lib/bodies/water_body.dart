import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';
import 'package:forge2d/src/dynamics/body.dart';
import 'package:juego/game/ugh_game.dart';

import '../players/water_player.dart';

class WaterBody extends BodyComponent<UghGame> with KeyboardHandler, ContactCallbacks{

  int horizontalDirection = 0;
  int verticalDirection = 0;

  Vector2 position;
  late WaterPlayer waterPlayer;

  final Vector2 velocityW = Vector2.zero();
  final double moveSpeedW = 200;

  WaterBody ({required this.position});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    waterPlayer = WaterPlayer(position: Vector2.zero());
    add(waterPlayer);
    renderBody = false;

  }

  @override
  void update(double dt) {
    // TODO: implement updateTree
    //position.add(Vector2(10.0 * horizontalDirection, 10.0 * verticalDirection));
    velocityW.x = horizontalDirection * moveSpeedW;
    velocityW.y = verticalDirection * moveSpeedW;
    //game.tiledComponent.position -= velocity * dt;

    center.add(velocityW * dt);

    //movimiento de flip-flop
    if (horizontalDirection < 0 && waterPlayer.scale.x > 0) {
      waterPlayer.flipHorizontally();
    } else if (horizontalDirection > 0 && waterPlayer.scale.x < 0) {
      waterPlayer.flipHorizontally();
    }

    if (position.x < -waterPlayer.size.x || game.health <= 0) {
      game.setDirection(0, 0);
      removeFromParent();
    }

    super.update(dt);
  }



  @override
  Body createBody() {

    BodyDef bodyDef = BodyDef(
      userData: this,
      position: position,
      type: BodyType.dynamic,
    );

    final shape = CircleShape()..radius = 16.0;
    final fixtureDef = FixtureDef(shape);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    //print("DEBUG: ---------------------->BOTON" + keysPressed.toString());
    horizontalDirection = 0;
    verticalDirection=0;

    //nomencatura ternaria de una if else.
    //posicion horizontal
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyA))
        ? -1
        : 0;

    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD))
        ? 1
        : 0;

    //posicion vertical
    verticalDirection += (keysPressed.contains(LogicalKeyboardKey.keyW))
        ? -1
        : 0;

    verticalDirection += (keysPressed.contains(LogicalKeyboardKey.keyS))
        ? 1
        : 0;

    game.setDirection(horizontalDirection, verticalDirection);

    return true;
  }

}