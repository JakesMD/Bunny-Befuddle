import 'package:flame/extensions.dart';

/// Provides extension methods for [Vector3].
extension BVector3X on Vector3 {
  /// Calculates the priority of the 3D position for the camera in an isometric
  /// space. This is used to determine the order in which the isometric objects
  /// are drawn.
  ///
  /// A position with a higher z value should be drawn in front of a position
  /// with a lower z value, no matter about their x or y values.
  ///
  /// A position with a higher y value should be drawn in front of a position
  /// with a lower y value, no matter about their x values.
  ///
  /// A position with a higher x value should be drawn in front of a position
  /// with a lower x value.
  int get isoPriority => z.floor() * 1000 * 1000 + y.floor() * 1000 + x.floor();

  /// Projects the 3D position onto a 2D plane isometrically.
  Vector2 get projectIso {
    final xOffset = Vector2(
      x * (_bHalfTileSize.x / 2),
      x * (_bHalfTileSize.y / 2),
    );

    final yOffset = Vector2(
      -y * (_bHalfTileSize.x / 2),
      y * (_bHalfTileSize.y / 2),
    );

    final zOffset = Vector2(0, -z * _bHalfTileSize.y);

    return Vector2(
      xOffset.x + yOffset.x + zOffset.x,
      xOffset.y + yOffset.y + zOffset.y,
    );
  }
}

final Vector2 _bHalfTileSize = Vector2.copy(_bHalfTileSize) * 0.5;
