import 'dart:math';

import 'package:bunny_befuddle/config.dart';
import 'package:bunny_befuddle/extensions/_extensions.dart';
import 'package:bunny_befuddle/models/_models.dart';
import 'package:flame/game.dart';

/// {@template BLevel}
///
/// A level in the game.
///
/// {@endtemplate}
class BLevel {
  /// {@macro BLevel}
  BLevel({required this.startPosition, required this.map}) {
    size = Vector3(
      map[0][0].length.toDouble(),
      map[0].length.toDouble(),
      map.length.toDouble(),
    );

    isometricSize =
        Vector2(
          max(
                Vector3(size.x, 0, 0).toIsometricPosition.x.abs(),
                Vector3(0, size.y, 0).toIsometricPosition.x.abs(),
              ) *
              2,
          max(
                Vector3(0, 0, size.z).toIsometricPosition.y.abs(),
                Vector3(size.x, size.y, 0).toIsometricPosition.y.abs(),
              ) *
              2,
        ) +
        bBlockSize;

    _entityMap = [];

    for (var z = 0; z < size.z; z++) {
      _entityMap.add([]);
      for (var y = 0; y < size.y; y++) {
        _entityMap[z].add([]);
        for (var x = 0; x < size.x; x++) {
          _entityMap[z][y].add(
            BWorldEntity(
              position: Vector3(x.toDouble(), y.toDouble(), z.toDouble()),
              number: map[z][y][x],
            ),
          );
        }
      }
    }

    numberOfCollectables = collectables().length;
  }

  /// The starting position of the player.
  final Vector3 startPosition;

  /// The map of the level containing the numbers/IDs of the world entities.
  ///
  /// ``` dart
  /// final blockNum = map[z][y][x]
  /// ```
  ///
  /// 0 represents empty space.
  /// Numbers < 200 represent blocks.
  /// Numbers >= 200 represent collectable items.
  final List<List<List<int>>> map;

  /// The length of the x, y, and z axes of the level in blocks.
  late final Vector3 size;

  /// The size of the level in isometric coordinates.
  ///
  /// This is used to calculate the size of the world / camera bounds.
  ///
  /// The width is the maximum between the center and the left/right sides,
  /// multiplied by 2.
  /// This means that the actual width of the level may be smaller than this
  /// width. In the case of a square, this width will be the same as the actual
  /// width.
  ///
  /// The height is the maximum between the center and the top/bottom sides,
  /// multiplied by 2.
  /// This means that the actual height of the level may be smaller than this
  /// height. In the case of a cube, this height will be the same as the actual
  /// height.
  ///
  /// The reason for calculating this in this "strange" way is to ensure that
  /// the level is always visible in the camera which has it's center at zero.
  /// The center of the level is not at zero, meaning that the camera would not
  /// be able to see the entire level if we did not compensate.
  late final Vector2 isometricSize;

  /// The number of collectable items in the level.
  late final int numberOfCollectables;

  late final List<List<List<BWorldEntity>>> _entityMap;

  /// Returns an iterable of all the entities in the level of the given type.
  Iterable<BWorldEntity> entitiesOfType(BWorldEntityType type) sync* {
    for (final z in _entityMap) {
      for (final y in z) {
        for (final x in y) {
          if (x.type == type) yield x;
        }
      }
    }
  }

  /// Returns an iterable of all the blocks in the level.
  Iterable<BWorldEntity> blocks() => entitiesOfType(BWorldEntityType.block);

  /// Returns an iterable of all the collectable items in the level.
  Iterable<BWorldEntity> collectables() =>
      entitiesOfType(BWorldEntityType.collectable);

  /// Fetches the block at the given position.
  BWorldEntity? fetchBlock(Vector3 position) {
    final z = position.z.floor();
    final y = position.y.floor();
    final x = position.x.floor();

    if (!_isWithinBounds(x, y, z)) return null;

    final entity = _entityMap[z][y][x];

    if (entity.type != BWorldEntityType.block) return null;

    return _entityMap[z][y][x];
  }

  /// Fetches the collectable item at the given position.
  BWorldEntity? fetchCollectable(Vector3 position) {
    final z = position.z.floor();
    final y = position.y.floor();
    final x = position.x.floor();

    if (!_isWithinBounds(x, y, z)) return null;

    final entity = _entityMap[z][y][x];

    if (entity.type != BWorldEntityType.collectable) return null;

    return _entityMap[z][y][x];
  }

  bool _isWithinBounds(int x, int y, int z) =>
      (z >= 0 && z < size.z) &&
      (y >= 0 && y < size.y) &&
      (x >= 0 && x < size.x);
}
