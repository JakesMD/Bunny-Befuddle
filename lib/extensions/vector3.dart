import 'package:bunny_befuddle/config.dart';
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
  int get isometricPriority =>
      z.floor() * 1000 * 1000 + y.floor() * 1000 + x.floor();

  /// Projects the 3D position onto a 2D plane isometrically.
  Vector2 get toIsometricPosition {
    final xOffset = Vector2(x * _bHalfTileSize.x, x * _bHalfTileSize.y);

    final yOffset = Vector2(-y * _bHalfTileSize.x, y * _bHalfTileSize.y);

    final zOffset = Vector2(0, -z * bTileSize.y);

    return Vector2(
      xOffset.x + yOffset.x + zOffset.x,
      xOffset.y + yOffset.y + zOffset.y,
    );
  }
}

final Vector2 _bHalfTileSize = bTileSize * 0.5;
