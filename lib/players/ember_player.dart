import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:forge2d/src/dynamics/body.dart';
import 'package:juego/players/water_player.dart';

import '../element/star_element.dart';
import '../game/ugh_game.dart';
//Creamos una clase player que extiende del Sprite.
//El Sprite es componente visual que tendra una animación de sprite
//Es como una imagen vertical alargada con distintos estados de un objeto
//Esto crea como una animación del objeto.
//La variable animación carga el Sprite desde cache, y le dirá las caracteristicas de la animacion

//Clase intermedia. Engloba al ember SAC.
class EmberBody extends BodyComponent<UghGame>{

  //no es un elemento que tiee posicion. Creamos la variable.
  Vector2 position;
  late EmberPlayer emberPlayer;

  //constructor con parametro de position.
  EmberBody({required this.position});

  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    await super.onLoad();
    emberPlayer = EmberPlayer(position: position);
    add(emberPlayer);
  }

  @override
  Body createBody() {
    // TODO: implement createBody
    BodyDef difinicionCuerpo = BodyDef(position: position, type: BodyType.dynamic);
    Body cuerpo = world.createBody(difinicionCuerpo);
    return cuerpo;
  }

}
class EmberPlayer extends SpriteAnimationComponent with HasGameRef<UghGame>, KeyboardHandler, CollisionCallbacks {

  EmberPlayer({
    required super.position,
    //Posicion redimensionada a 32. Original : 64. Necesidad de redimensionar mapa.
  }) : super(size: Vector2.all(32), anchor: Anchor.center);

  int horizontalDirection = 0;
  int verticalDirection = 0;

  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;

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

    //cargamos el cuerpo del personaje. Ciruclo por su forma circular.
    add(
      //podriamos guardarlo como variable.
      CircleHitbox(),
    );
  }

  //deteccion de las teclas del teclado y movimiento
  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    //print("DEBUG: ---------------------->BOTON" + keysPressed.toString());
    horizontalDirection = 0;
    verticalDirection=0;

    //nomencatura ternaria de una if else.
    //posicion horizontal
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;

    //posicion vertical
    verticalDirection += (keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp))
        ? -1
        : 0;
    verticalDirection += (keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown))
        ? 1
        : 0;

    game.setDirection(horizontalDirection, verticalDirection);

    return true;
  }

  //colisiones
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    print("DEBUG----->>> COLLISIONNNNNNNNNNNNNNNN");
    if (other is StarElement) {
      other.removeFromParent();
      game.starsCollected++;
    }

    if (other is WaterPlayer) {
      hit();
    }
    super.onCollision(intersectionPoints, other);
  }

  //función que define que hace ember cuando choca con water.
  void hit() {
    if (!hitByEnemy) {
      game.health--;
      hitByEnemy = true;
    }
    //el mete este trocho de codigo dentro del if, pero no entiendo bien para que. Lo dejo como en el tutorial.
    add(
      OpacityEffect.fadeOut(
        EffectController(
          alternate: true,
          duration: 0.1,
          repeatCount: 4,
        ),
      )..onComplete = () {
        hitByEnemy = false;
      },
    );
  }

  @override
  void update(double dt) {
    // TODO: implement updateTree
    //position.add(Vector2(10.0 * horizontalDirection, 10.0 * verticalDirection));
    //velocity.x = horizontalDirection * moveSpeed;
    //velocity.y = verticalDirection * moveSpeed;
    //game.tiledComponent.position -= velocity * dt;

    //movimiento de flip-flop
    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    if (position.x < -size.x || game.health <= 0) {
      game.setDirection(0, 0);
      removeFromParent();
    }

    super.update(dt);
  }

}