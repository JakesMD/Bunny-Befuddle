import 'dart:async';
import 'dart:ui';

import 'package:bunny_befuddle/components/_components.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

/// {@template BSkyComponent}
///
/// A component that renders a number of clouds that move across the
/// screen.
///
/// {@endtemplate}
class BSkyComponent extends PositionComponent
    with HasWorldReference<BLevelWorld> {
  /// {@macro BSkyComponent}
  BSkyComponent({required this.numberOfClouds});

  /// The number of clouds at any given time.
  ///
  /// Note: Not all the clouds will be within the camera's viewport.
  final int numberOfClouds;

  @override
  FutureOr<void> onLoad() async {
    await Flame.images.loadAll([
      'cloud_1.png',
      'cloud_2.png',
      'cloud_3.png',
      'cloud_4.png',
    ]);

    anchor = Anchor.topLeft;
    size = world.size;
    position = Vector2.zero();

    add(
      RectangleComponent(
        size: size,
        priority: -1,
        paint: Paint()..color = const Color(0xffD0F4F7),
      ),
    );

    for (var i = 0; i < numberOfClouds; i++) {
      add(BCloudComponent());
    }
  }
}
