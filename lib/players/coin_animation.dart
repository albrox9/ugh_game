import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../game/ugh_game.dart';

class CoinAnimation extends SpriteAnimationComponent with HasGameRef<UghGame> {

  CoinAnimation({
    required super.position,
    //Posicion redimensionada a 32. Original : 64. Necesidad de redimensionar mapa.
  }) : super(size: Vector2(32,32), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      //accede a la cache de la carga de imagenes que hicimos en UghGame
      //Cargo las imagenes al principio, y no las cargo a cada objeto.
      //También se pueden cargar aquí recursos para no cargarlo todo al arrancar
      game.images.fromCache('coin.png'),
      SpriteAnimationData.sequenced(
        amount: 4, //2 estados de animacion.
        textureSize: Vector2.all(32), //16 es el valor del ancho y alto ¿?
        stepTime: 0.12, //velocidad a la que cambia la animación a través de los 4 estados
      ),
    );

    //le agrego un cuerpo a water
    add(CircleHitbox()
      ..collisionType = CollisionType.passive);


    @override
    void update(double dt) {
      // TODO: implement update
      if (game.health <= 0) {
        removeFromParent();
      }
      super.update(dt);
    }
  }
}