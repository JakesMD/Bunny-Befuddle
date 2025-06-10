import 'package:flame/components.dart';

/// The type of the world entity.
enum BWorldEntityType {
  /// An empty space in the world.
  space,

  /// A building block of the world, e.g. a rock.
  block,

  /// A collectable item, e.g. a carrot.
  collectable,
}

/// {@template BWorldEntity}
///
/// Represents a block or a collectable item that make up the world.
///
/// {@endtemplate}
class BWorldEntity {
  /// {@macro BWorldEntity}
  const BWorldEntity({required this.position, required this.number});

  /// The position of the entity in 3D space.
  final Vector3 position;

  /// The number/ID of the entity.
  ///
  /// This is used to determine the type and image of the entity.
  ///
  /// `number` < 200 represents a block.
  /// `number` >= 200 represents a collectable item.
  final int number;

  /// The type of the entity.
  BWorldEntityType get type => number == 0
      ? BWorldEntityType.space
      : number < 200
      ? BWorldEntityType.block
      : BWorldEntityType.collectable;
}
