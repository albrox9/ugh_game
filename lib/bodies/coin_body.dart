import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:juego/bodies/ember_body.dart';
import 'package:juego/players/coin_animation.dart';

import '../game/ugh_game.dart';
import '../players/ember_player.dart';

class CoinBody extends BodyComponent<UghGame> with ContactCallbacks{

  Vector2 position;
  late CoinAnimation coinAnimation;

  CoinBody({required this.position});

  @override
  Future<void> onLoad() async {
    // TODO: implement onLoad
    await super.onLoad();
    coinAnimation = CoinAnimation(position: Vector2.zero());
    //pongo la posicion a 0, para que no se solape con la del emberplayer.
    add(coinAnimation);
    renderBody = false;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: position,
      type: BodyType.static,
    );
     final shape = CircleShape()..radius = 16.0;
     final fixtureDef = FixtureDef(shape);
     return world.createBody(bodyDef)..createFixture(fixtureDef);
  }




}