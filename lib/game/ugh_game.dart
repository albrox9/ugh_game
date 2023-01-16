import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:juego/bodies/suelo_body.dart';
import 'package:juego/overlays/hud.dart';
import 'package:juego/players/ember_player.dart';
import 'package:flutter/material.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import '../element/star_element.dart';
import '../players/coin_animation.dart';
import '../players/water_player.dart';
import '../ux/joypad.dart';

class UghGame extends Forge2DGame with HasKeyboardHandlerComponents, HasCollisionDetection {


  late TiledComponent tiledComponent;
  int verticalDirection = 0;
  int horizontalDirection = 0;

  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;

  //variables para la vida, usadas en el heart_health
  int starsCollected = 0;
  int health = 3;

  late EmberBody _emberBody;

  List <PositionComponent> objetosVisuales = [];

  UghGame():super(gravity: Vector2(0, 9.8), zoom: 1);

  //Funcion que carga todos los recursos del juego.
  //Es futuro y puede ser asíncrono.
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await images.loadAll([
      'block.png',
      'ember.png',
      'ground.png',
      'coin.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
    ]);

    //initializeGame(true);

    //Posicion redimensionada a 32. Original : 64. Necesidad de redimensionar mapa. No cabia en pantalla.
    tiledComponent = await TiledComponent.load('tile-32.tmx', Vector2.all(32));
    add(tiledComponent);


  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }

  @override
  void update(double dt) {

    //position.add(Vector2(10.0 * horizontalDirection, 10.0 * verticalDirection));
    velocity.x = horizontalDirection * moveSpeed;
    velocity.y = verticalDirection * moveSpeed;
    tiledComponent.position -= velocity * dt;

    //recorre la lista de objetos visuales
    for(final objVisual in objetosVisuales ){
      objVisual.position -= velocity * dt;
    }

    if (health <= 0) {
      overlays.add('GameOver');
    }

    super.update(dt);
  }

  //funcion para mover el mapa.
  void setDirection (int horizontalDirection, int verticalDirection){

    this.verticalDirection = verticalDirection;
    this.horizontalDirection = horizontalDirection;

  }

  Future<void> initializeGame(bool loadHud) async {

    //limpio el array de los objetos visuales viejos.
    objetosVisuales.clear();
    //posicionamos el mapa de nuevo.
    tiledComponent.position = Vector2(0,0);

    //ObjectGroup? stars = tiledComponent.tileMap.getLayer<ObjectGroup>("stars");
    ObjectGroup? coin = tiledComponent.tileMap.getLayer<ObjectGroup>("coin");
    ObjectGroup? water = tiledComponent.tileMap.getLayer<ObjectGroup>("water");
    ObjectGroup? posinitplayer = tiledComponent.tileMap.getLayer<ObjectGroup>("posinitplayer");
    ObjectGroup? plataformas = tiledComponent.tileMap.getLayer<ObjectGroup>("plataformas");

    //añadimos los suelos
   for (final plataformas in plataformas!.objects) {
      add(SueloBody(tiledObject: plataformas));
    }

    //añadimos los componenetes water al array y al juego.
    for (final water in water!.objects) {
      WaterPlayer waterPlayer = WaterPlayer(position: Vector2(water.x, water.y));
      objetosVisuales.add(waterPlayer);
      add(waterPlayer);
    }

    //añado los componenete estrella al array y al juego.
    /*for (final stars in stars!.objects) {
      StarElement starElement = StarElement(position: Vector2(stars.x, stars.y));
      objetosVisuales.add(starElement);
      add(starElement);
    }*/

    //añado monedas.
    for (final coin in coin!.objects) {
      CoinAnimation coinPlayer = CoinAnimation(position: Vector2(coin.x, coin.y));
      objetosVisuales.add(coinPlayer);
      add(coinPlayer);
    }


    _emberBody = EmberBody(position: Vector2(posinitplayer!.objects.first.x,posinitplayer!.objects.first.y));
    add(_emberBody);

    if (loadHud) {
      add(Hud());
    }
  }

  void reset() {
    starsCollected = 0;
    health = 3;
    initializeGame(false);
  }

  void joypadMoved(Direction direction){

    horizontalDirection = 0;
    verticalDirection=0;

    print("JOYPAD EN MOVIMIENTO: ----->" + direction.toString());

    horizontalDirection += (direction == Direction.left)
        ? -1
        : 0;
    horizontalDirection += (direction == Direction.right)
        ? 1
        : 0;

    //posicion vertical
    verticalDirection += (direction == Direction.up)
        ? -1
        : 0;
    verticalDirection += (direction == Direction.down)
        ? 1
        : 0;

    //pinta hacia donde va el muñeco. LE hace que cambie de dirección
    _emberBody.emberPlayer.horizontalDirection=horizontalDirection;

  }

}

