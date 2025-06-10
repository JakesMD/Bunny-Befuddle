import 'dart:async';
import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';

/// The main game class for Bunny Befuddle.
class BGame extends FlameGame with HasKeyboardHandlerComponents {
  @override
  Future<void> onLoad() async {
    unawaited(FlameAudio.bgm.play('background_music.mp3', volume: 0.5));
  }

  @override
  Color backgroundColor() => const Color(0xffD0F4F7);

  @override
  void onDispose() {
    super.onDispose();
    FlameAudio.bgm.dispose();
  }
}
