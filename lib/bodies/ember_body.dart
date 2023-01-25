import 'dart:html';

import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:juego/bodies/water_body.dart';

import '../game/ugh_game.dart';
import '../players/ember_player.dart';
import 'coin_body.dart';

class EmberBody extends BodyComponent<UghGame> with KeyboardHandler, ContactCallbacks{

  //no es un elemento que tiee posicion. Creamos la variable.
  Vector2 position;
  //defino tamaño del body.
  //Vector2 size = Vector2(32,32);

  late EmberPlayer emberPlayer;

  int horizontalDirection = 0;
  int verticalDirection = 0;

  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;

  //constructor con parametro de position.
  EmberBody({required this.position});

  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    await super.onLoad();
    //pongo la posicion a 0, para que no se solape con la del emberplayer.
    emberPlayer = EmberPlayer(position: Vector2.zero(), size: Vector2(32, 32));
    //emberPlayer.size = size;
    add(emberPlayer); //cuando activo esto, el juego no se inicia.
    renderBody = false;
  }

  @override
  void onMount() {
    // TODO: implement onMount
    super.onMount();
    camera.followBodyComponent(this);
  }

  @override
  void update(double dt) {
    // TODO: implement updateTree
    //position.add(Vector2(10.0 * horizontalDirection, 10.0 * verticalDirection));
    velocity.x = horizontalDirection * moveSpeed;
    velocity.y = verticalDirection * moveSpeed;
    //game.tiledComponent.position -= velocity * dt;

    center.add(velocity * dt);

    //movimiento de flip-flop
    if (horizontalDirection < 0 && emberPlayer.scale.x > 0) {
      emberPlayer.flipHorizontally();
    } else if (horizontalDirection > 0 && emberPlayer.scale.x < 0) {
      emberPlayer.flipHorizontally();
    }

    if (position.x < -emberPlayer.size.x || game.health <= 0) {
      game.setDirection(0, 0);
      removeFromParent();
    }

    super.update(dt);
  }

  @override
  Body createBody() {
    // TODO: implement createBody
    BodyDef difinicionCuerpo = BodyDef(
        userData: this,
        position: position,
        type: BodyType.dynamic);
    Body cuerpo = world.createBody(difinicionCuerpo);

    //Ahora el poligono, a ver si funciona
    final shape = CircleShape();
    shape.radius = 16.0;

    //en el cuerpo se crea una forma interna.
    FixtureDef fixtureDef = FixtureDef(shape);
    cuerpo.createFixture(fixtureDef);
    return cuerpo;
  }

  //colisiones
  @override
  void beginContact(Object other, Contact contact) {
    if (other is CoinBody) {
      game.coinCollected++;
      other.removeFromParent();
    }

    if (other is WaterBody){
      emberPlayer.hit();
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    //print("DEBUG: ---------------------->BOTON" + keysPressed.toString());
    horizontalDirection = 0;
    verticalDirection=0;

    //nomencatura ternaria de una if else.
    //posicion horizontal
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;

    //posicion vertical
    verticalDirection += (keysPressed.contains(LogicalKeyboardKey.arrowUp))
        ? -1
        : 0;
    verticalDirection += (keysPressed.contains(LogicalKeyboardKey.arrowDown))
        ? 1
        : 0;

    game.setDirection(horizontalDirection, verticalDirection);

    return true;
  }

}
