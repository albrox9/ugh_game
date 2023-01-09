import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:juego/game/ugh_game.dart';
import 'package:juego/ux/joypad.dart';
import 'package:juego/widgets/game_over_menu.dart';
import 'package:juego/widgets/main_menu.dart';

/*void main() {
  final game = FlameGame();
  runApp(GameWidget(game: game));
}*/

void main() {
  runApp(
    GameWidget<UghGame>.controlled(
      gameFactory: UghGame.new,
      overlayBuilderMap: {
        'MainMenu': (_, game) => MainMenu(game: game),
        'GameOver': (_, game) => GameOver(game: game),
        'Joypad': (_, game) => Joypad(onDirectionChanged: game.joypadMoved),
      },
      initialActiveOverlays: const ['MainMenu'],
    ),
  );
}

