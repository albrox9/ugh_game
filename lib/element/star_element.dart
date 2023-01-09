import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:juego/game/ugh_game.dart';

class StarElement extends SpriteComponent with HasGameRef<UghGame> {

  //Posicion redimensionada a 32. Original : 64. Necesidad de redimensionar mapa.
  StarElement({required super.position}) : super(size: Vector2.all(32), anchor: Anchor.center);

  @override
  Future<void>? onLoad() async{
    // TODO: implement onLoad
    await super.onLoad();

    //carga la imagen
    final platformImage = game.images.fromCache('star.png');
    //crea un sprite de la imagen
    sprite = Sprite(platformImage);

    //damos un cuerpo para que se den las colisiones. Le da prioridad al obj activo.
    add(RectangleHitbox()..collisionType = CollisionType.passive);

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

