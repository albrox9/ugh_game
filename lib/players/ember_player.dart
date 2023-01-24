import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:forge2d/src/dynamics/body.dart';
import 'package:juego/bodies/coin_body.dart';
import 'package:juego/players/water_player.dart';
import '../game/ugh_game.dart';
//Creamos una clase player que extiende del Sprite.
//El Sprite es componente visual que tendra una animación de sprite
//Es como una imagen vertical alargada con distintos estados de un objeto
//Esto crea como una animación del objeto.
//La variable animación carga el Sprite desde cache, y le dirá las caracteristicas de la animacion

//Clase intermedia. Engloba al ember SAC.

class EmberPlayer extends SpriteAnimationComponent with HasGameRef<UghGame>, KeyboardHandler {

  EmberPlayer({
    required super.position, super.size
    //Posicion redimensionada a 32. Original : 64. Necesidad de redimensionar mapa.
  }) : super(anchor: Anchor.center);

  bool hitByEnemy = false;

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      //accede a la cache de la carga de imagenes que hicimos en UghGame
      //Cargo las imagenes al principio, y no las cargo a cada objeto.
      //También se pueden cargar aquí recursos para no cargarlo todo al arrancar
      game.images.fromCache('ember.png'),
      SpriteAnimationData.sequenced(
        amount: 4, //4 estados de animacion.
        textureSize: Vector2.all(16), //16 es el valor del ancho y alto ¿?
        stepTime: 0.12, //velocidad a la que cambia la animación a través de los 4 estados
      ),
    );
  }

  void hit() {
    if (!hitByEnemy) {
      hitByEnemy = true;
    }
    add(
      OpacityEffect.fadeOut(
        EffectController(
          alternate: true,
          duration: 0.1,
          repeatCount: 6,
        ),
      )..onComplete = () {
        hitByEnemy = false;
      },
    );
  }
}



