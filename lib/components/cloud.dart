import 'dart:math';

import 'package:bunny_befuddle/config.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

/// {@template BCloudComponent}
///
/// A component that renders a single cloud.
///
/// The cloud will randomly decide, how far away it should be from the camera
/// and based on that, will adjust its size, speed and priority.
///
/// Once the cloud moves off the sky, it will remove itself from the parent
/// and add a new cloud to the parent.
///
/// The cloud will also move with the camera in a parallax way.
///
/// {@endtemplate}
class BCloudComponent extends SpriteComponent {
  /// {@macro BCloudComponent}
  BCloudComponent({
    required this.skySize,
    required this.cameraPosition,
    this.isSpawn = false,
  });

  /// Whether the cloud is a spawn of a cloud that has moved off the sky.
  ///
  /// When true, the cloud will start from the right side of the sky.
  /// When false, the cloud will start from a random x position.
  final bool isSpawn;

  /// The size of the sky.
  final Vector2 skySize;

  /// The position of the camera.
  final Vector2 Function() cameraPosition;

  late double _depthFactor;
  late Vector2 _relativePosition;

  @override
  Future<void> onLoad() async {
    _depthFactor = _random.nextDouble();

    sprite = Sprite(
      Flame.images.fromCache('cloud_${_random.nextInt(3) + 1}.png'),
    );
    scale = Vector2.all(_depthFactor * 1.5);
    priority = (_depthFactor * 10).toInt();
    anchor = Anchor.center;

    const largestWidth = 216 * 1.5;

    if (_random.nextBool()) flipHorizontallyAroundCenter();

    _relativePosition = Vector2(
      (isSpawn
              ? 0.0
              : _random
                    .nextInt((skySize.x + largestWidth * 2).toInt())
                    .toDouble()) -
          largestWidth,
      _random.nextInt(skySize.y.toInt()).toDouble(),
    );
  }

  @override
  void update(double dt) {
    position = _relativePosition - cameraPosition() * _depthFactor;
    _relativePosition.x += _depthFactor * bCloudVelocity * dt;

    if (_relativePosition.x > (skySize.x + size.x * 0.5)) {
      parent?.remove(this);
      parent?.add(
        BCloudComponent(
          skySize: skySize,
          cameraPosition: cameraPosition,
          isSpawn: true,
        ),
      );
    }
  }
}

final _random = Random();
