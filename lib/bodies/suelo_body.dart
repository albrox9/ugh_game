import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:forge2d/src/dynamics/body.dart';
import 'package:juego/game/ugh_game.dart';

class SueloBody extends BodyComponent<UghGame>{

  TiledObject tiledObject;
  SueloBody({required this.tiledObject});

  @override
  Body createBody() {

    late FixtureDef fixtureDef;

    if(tiledObject.isPolygon){

      ChainShape shape = ChainShape();
      List <Vector2> vertices = [];

      for(final point in tiledObject.polygon){
        shape.vertices.add(Vector2(point.x, point.y));
      }

      Point point0 = tiledObject.polygon[0];
      shape.vertices.add(Vector2(point0.x, point0.y));
      //shape.set(vertices);

      fixtureDef = FixtureDef(shape);

    }

    BodyDef difinicionCuerpo = BodyDef(position: Vector2(tiledObject.x, tiledObject.y), type: BodyType.static);
    Body cuerpo = world.createBody(difinicionCuerpo);

    cuerpo.createFixture(fixtureDef);
    return cuerpo;
  }

}