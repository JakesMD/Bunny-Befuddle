import 'dart:async';

import 'package:bunny_befuddle/components/_components.dart';
import 'package:bunny_befuddle/config.dart';
import 'package:bunny_befuddle/extensions/_extensions.dart';
import 'package:bunny_befuddle/models/_models.dart';
import 'package:flame/components.dart';

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
  final int _number;

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load(
      'block_${_number.toString().padLeft(3, '0')}.png',
    );
    anchor = Anchor.topCenter;
    priority = _position3D.isometricPriority;
    position =
        _position3D.toIsometricPosition -
        Vector2(0, bTileSize.y) +
        world.size * 0.5;
  }
}
