import 'dart:async';

import 'package:bunny_befuddle/components/_components.dart';
import 'package:bunny_befuddle/config.dart';
import 'package:bunny_befuddle/game.dart';
import 'package:bunny_befuddle/models/_models.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

/// {@template BLevelWorld}
///
/// The world that contains the level.
///
/// {@endtemplate}
class BLevelWorld extends World with HasGameReference<BGame> {
  /// {@macro BLevelWorld}
  BLevelWorld({
    required this.level,
    required this.camera,
    required this.nextLevel,
  });

  /// The level that is being played.
  final BLevel level;

  /// The camera that is viewing the world.
  ///
  /// The world must be added to this camera.
  final CameraComponent camera;

  /// The name of the route to go to after the level is completed.
  final String nextLevel;

  /// The size of the 2D world.
  Vector2 get size {
    final tempSize = level.isometricSize + bBlockSize * 10;
    if (tempSize.x < game.size.x) tempSize.x = game.size.x;
    if (tempSize.y < game.size.y) tempSize.y = game.size.y;
    return tempSize;
  }

  /// The position of the player in 3D space.
  Vector3 get playerPosition3D => _bunny.position3D.clone();

  /// Whether the level is complete.
  bool get isLevelComplete => _score == level.numberOfCollectables;

  late final BBunnyComponent _bunny;

  int _score = 0;

  final _collectables = <BCollectableComponent>[];

  /// Adds a carrot to the score.
  void incrementScore() => _score++;

  /// Moves to the next level.
  void goToNextLevel() => game.router.pushReplacementNamed(nextLevel);

  /// Resets the level.
  void reset() {
    _score = 0;
    _bunny.reset();
    for (final collectable in _collectables) {
      if (collectable.isRemoved) add(collectable);
    }
  }

  @override
  FutureOr<void> onLoad() {
    for (final block in level.blocks()) {
      add(BBlockComponent.fromEntity(block));
    }

    for (final collectable in level.collectables()) {
      _collectables.add(BCollectableComponent.fromEntity(collectable));
    }

    addAll(_collectables);

    _bunny = BBunnyComponent();
    add(_bunny);

    _setupCamera();
    camera.follow(_bunny);
    camera.viewport.add(
      BControlsComponent(
        onLeftPressed: _bunny.moveLeft,
        onRightPressed: _bunny.moveRight,
        onForwardPressed: _bunny.moveForward,
        onBackwardPressed: _bunny.moveBackward,
        onDirectionReleased: _bunny.standStill,
        onJumpPressed: _bunny.jump,
      ),
    );
  }

  @override
  void onGameResize(Vector2 size) {
    _setupCamera();
    super.onGameResize(size);
  }

  void _setupCamera() {
    camera.backdrop
      ..removeWhere((c) => c is BSkyComponent)
      ..add(
        BSkyComponent(
          cameraPosition: () => camera.viewfinder.position,
          size: size,
        ),
      );
    camera.setBounds(Rectangle.fromCenter(size: size, center: Vector2.zero()));
  }
}
