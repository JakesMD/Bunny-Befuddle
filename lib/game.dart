import 'dart:async';

import 'package:bunny_befuddle/levels/_levels.dart';
import 'package:bunny_befuddle/worlds/_worlds.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

/// The main game class for Bunny Befuddle.
class BGame extends FlameGame with HasKeyboardHandlerComponents {
  /// The router component for the game.
  late final RouterComponent router;

  @override
  Future<void> onLoad() async {
    if (!kDebugMode) {
      unawaited(FlameAudio.bgm.play('background_music.mp3', volume: 0.25));
    }

    router = RouterComponent(
      routes: {
        'level1': WorldRoute(
          () =>
              BLevelWorld(level: bLevel1, camera: camera, nextLevel: 'level2'),
          maintainState: false,
        ),
        'level2': WorldRoute(
          () =>
              BLevelWorld(level: bLevel2, camera: camera, nextLevel: 'level3'),
          maintainState: false,
        ),
        'level3': WorldRoute(
          () =>
              BLevelWorld(level: bLevel3, camera: camera, nextLevel: 'level1'),
          maintainState: false,
        ),
      },
      initialRoute: 'level1',
    );

    add(router);
  }

  @override
  void onDispose() {
    if (!kDebugMode) FlameAudio.bgm.dispose();
  }
}
