import 'dart:async';

import 'package:bunny_befuddle/components/_components.dart';
import 'package:bunny_befuddle/levels/_levels.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

/// The main game class for Bunny Befuddle.
class BGame extends FlameGame with HasKeyboardHandlerComponents {
  @override
  Future<void> onLoad() async {
    if (!kDebugMode) {
      unawaited(FlameAudio.bgm.play('background_music.mp3', volume: 0.25));
    }

    add(
      RouterComponent(
        routes: {
          'level1': WorldRoute(
            () => BLevelWorld(level: bLevel1, camera: camera),
          ),
        },
        initialRoute: 'level1',
      ),
    );
  }

  @override
  void onDispose() {
    if (!kDebugMode) FlameAudio.bgm.dispose();
  }
}
