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

  /// The length of the x, y, and z axes of the level in entities.
  late final Vector3 size;

  late final List<List<List<BWorldEntity>>> _entityMap;

  /// Returns an iterable of all the blocks in the level.
  Iterable<BWorldEntity> blocks() sync* {
    for (final z in _entityMap) {
      for (final y in z) {
        for (final x in y) {
          if (x.type == BWorldEntityType.block) yield x;
        }
      }
    }
  }

  /// Fetches the proximity of blocks around the given position.
  BBlockProximity fetchProximity(Vector3 position) {
    final z = position.z.floor();
    final y = position.y.floor();
    final x = position.x.floor();

    if (!_isWithinBounds(x, y, z)) {
      return const BBlockProximity(isBlockWithin: false, isBlockBelow: false);
    }

    return BBlockProximity(
      isBlockWithin: _entityMap[z][y][x].type == BWorldEntityType.block,
      isBlockBelow:
          z > 0 && _entityMap[z - 1][y][x].type == BWorldEntityType.block,
    );
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
