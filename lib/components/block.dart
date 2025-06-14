import 'dart:async';

import 'package:bunny_befuddle/config.dart';
import 'package:bunny_befuddle/extensions/_extensions.dart';
import 'package:bunny_befuddle/models/_models.dart';
import 'package:bunny_befuddle/worlds/_worlds.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

/// {@template BBlockComponent}
///
/// A building block component of the world, e.g. a rock.
///
/// {@endtemplate}
class BBlockComponent extends SpriteComponent
    with HasWorldReference<BLevelWorld> {
  /// {@macro BBlockComponent}
  BBlockComponent.fromEntity(BWorldEntity entity)
    : _position3D = entity.position,
      _number = entity.number;

  final Vector3 _position3D;
  int _number;

  String _imageName(int number) =>
      'block_${number.toString().padLeft(3, '0')}.png';

  @override
  FutureOr<void> onLoad() async {
    await Flame.images.loadAll([
      _imageName(_number),
      if (_number == bRedFrameBlockNumber) _imageName(bGreenFrameBlockNumber),
      if (_number == bRedPuzzleBlockNumber) _imageName(bGreenPuzzleBlockNumber),
    ]);

    sprite = Sprite(Flame.images.fromCache(_imageName(_number)));
    anchor = Anchor.topCenter;
    priority = _position3D.isometricPriority;
    position = _position3D.toIsometricPosition - Vector2(0, bBlockSize.y);
  }

  @override
  void update(double dt) {
    if (world.isLevelComplete) {
      if (_number == bRedFrameBlockNumber) {
        _number = bGreenFrameBlockNumber;
        sprite!.image = Flame.images.fromCache(_imageName(_number));
      } else if (_number == bRedPuzzleBlockNumber) {
        _number = bGreenPuzzleBlockNumber;
        sprite!.image = Flame.images.fromCache(_imageName(_number));
      } else if (_number == bGreenPuzzleBlockNumber) {
        if ((world.playerPosition3D..floor()) ==
            (_position3D - Vector3(0, 0, 1))) {
          world.goToNextLevel();
        }
      }
    } else {
      if (_number == bGreenFrameBlockNumber) {
        _number = bRedFrameBlockNumber;
        sprite!.image = Flame.images.fromCache(_imageName(_number));
      } else if (_number == bGreenPuzzleBlockNumber) {
        _number = bRedPuzzleBlockNumber;
        sprite!.image = Flame.images.fromCache(_imageName(_number));
      }
    }
  }
}
