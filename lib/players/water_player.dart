import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../game/ugh_game.dart';

class WaterPlayer extends SpriteAnimationComponent with HasGameRef<UghGame> {

  WaterPlayer({required super.position}) : super(size: Vector2.all(32), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('water_enemy.png'),
      SpriteAnimationData.sequenced(
        amount: 2, //2 estados de animacion.
        textureSize: Vector2.all(16), //16 es el valor del ancho y alto ¿?
        stepTime: 0.12, //velocidad a la que cambia la animación a través de los 4 estados
      ),
    );


  }

  @override
  void update(double dt) {
    // TODO: implement update
    if (game.health <= 0) {
      removeFromParent();
    }
    super.update(dt);
  }


}