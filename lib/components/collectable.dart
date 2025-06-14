import 'package:bunny_befuddle/config.dart';
import 'package:bunny_befuddle/extensions/_extensions.dart';
import 'package:bunny_befuddle/models/_models.dart';
import 'package:bunny_befuddle/worlds/_worlds.dart';
import 'package:flame/components.dart';

/// {@template BCollectableComponent}
///
/// A collectable component of the world, e.g. a carrot.
///
/// When the player is on the same block as the collectable, the collectable
/// will be removed from the world and the player's score will be increased.
///
/// {@endtemplate}
class BCollectableComponent extends SpriteComponent
    with HasWorldReference<BLevelWorld> {
  /// {@macro BCollectableComponent}
  BCollectableComponent.fromEntity(BWorldEntity item)
    : _position3D = item.position,
      _number = item.number;

  final Vector3 _position3D;
  final int _number;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('collectable_$_number.png');
    anchor = Anchor.topCenter;
    scale = Vector2.all(0.4);
    priority = _position3D.isometricPriority;
    position = _position3D.toIsometricPosition + Vector2(0, bBlockSize.y / 4);
  }

  @override
  void update(double dt) {
    final posFloored = _position3D..floor();
    final playerPosFloored = world.playerPosition3D..floor();

    if (posFloored == playerPosFloored) {
      removeFromParent();
      world.incrementScore();
    }
  }
}
