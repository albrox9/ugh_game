import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:juego/bodies/coin_body.dart';
import 'package:juego/bodies/suelo_body.dart';
import 'package:juego/bodies/water_body.dart';
import 'package:juego/overlays/hud.dart';
import 'package:juego/players/ember_player.dart';
import 'package:flutter/material.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/parallax.dart';
import '../bodies/ember_body.dart';
import '../players/coin_animation.dart';
import '../players/water_player.dart';
import '../ux/joypad.dart';

class UghGame extends Forge2DGame with HasKeyboardHandlerComponents, ContactCallbacks {


  late TiledComponent tiledComponent;
  int verticalDirection = 0;
  int horizontalDirection = 0;

  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;

  //variables para la vida, usadas en el heart_health
  int coinCollected = 0;
  int health = 3;

  late EmberBody _emberBody;
  late CoinBody _coinBody;
  late WaterBody _waterBody;

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
      'coinOnly.png',
      'heart_half.png',
      'heart.png',
      'fondo.png',
      'water_enemy.png',

    ]);


    ParallaxComponent background = await ParallaxComponent.load([
      ParallaxImageData('fondo.png'),

    ],

        baseVelocity: Vector2(20, 0),
        velocityMultiplierDelta: Vector2(1.8, 1.0),

    );

    add(background);


    /*SpriteComponent image = SpriteComponent()
    ..sprite = await loadSprite('fondo.png')
    ..size = worldToScreen(Vector2(canvasSize.x, canvasSize.y));



    add(image);*/

    //Posicion redimensionada a 32. Original : 64. Necesidad de redimensionar mapa. No cabia en pantalla.
    tiledComponent = await TiledComponent.load('tile-32.tmx', Vector2.all(32));
    add(tiledComponent);

    //initializeGame(true);




  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }

  @override
  void update(double dt) {

    //position.add(Vector2(10.0 * horizontalDirection, 10.0 * verticalDirection));
    //velocity.x = horizontalDirection * moveSpeed;
    //velocity.y = verticalDirection * moveSpeed;
    //tiledComponent.position -= velocity * dt;

    //recorre la lista de objetos visuales
    //for(final objVisual in objetosVisuales ){
      //objVisual.position -= velocity * dt;
    //}

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


    //añado monedas.
    for (final coin in coin!.objects) {
      _coinBody = CoinBody(position: Vector2(coin.x, coin.y));
      add(_coinBody);
    }

    _waterBody = WaterBody(position: Vector2(water!.objects.first.x, posinitplayer!.objects.first.y));
    add(_waterBody);

    _emberBody = EmberBody(position: Vector2(posinitplayer!.objects.first.x,posinitplayer!.objects.first.y));
    add(_emberBody);



    if (loadHud) {
      add(Hud());
    }
  }

  void reset() {
    coinCollected = 0;
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
    _emberBody.horizontalDirection=horizontalDirection;

  }

}

