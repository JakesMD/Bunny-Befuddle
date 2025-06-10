import 'dart:async';

import 'package:bunny_befuddle/components/_components.dart';
import 'package:flame/components.dart';

/// {@template BLevelWorld}
///
/// The world that contains the level.
///
/// {@endtemplate}
class BLevelWorld extends World with HasGameReference {
  /// {@macro BLevelWorld}
  BLevelWorld({required this.camera});

  /// The camera that is viewing the world.
  ///
  /// The world must be added to this camera.
  final CameraComponent camera;

  /// The current position of the player in the 2D world.
  Vector2 get playerPosition => Vector2.zero();

  /// The size of the 2D world.
  Vector2 get size => game.size * 3;

  @override
  FutureOr<void> onLoad() {
    add(BSkyComponent(numberOfClouds: 50));
    camera.moveTo(size / 2);
  }
}
