import 'dart:async';
import 'dart:ui';

import 'package:bunny_befuddle/components/_components.dart';
import 'package:bunny_befuddle/config.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

/// {@template BSkyComponent}
///
/// A component that renders a number of clouds that move across the
/// screen.
///
/// ### About clouds:
/// {@macro BCloudComponent}
///
/// {@endtemplate}
class BSkyComponent extends PositionComponent {
  /// {@macro BSkyComponent}
  BSkyComponent({required this.cameraPosition, required super.size});

  /// The position of the camera.
  final Vector2 Function() cameraPosition;

  @override
  FutureOr<void> onLoad() async {
    await Flame.images.loadAll([
      'cloud_1.png',
      'cloud_2.png',
      'cloud_3.png',
      'cloud_4.png',
    ]);

    anchor = Anchor.topLeft;

    add(
      RectangleComponent(
        size: size,
        priority: -1,
        paint: Paint()..color = const Color(0xffD0F4F7),
      ),
    );

    for (var i = 0; i < bNumberOfClouds; i++) {
      add(BCloudComponent(skySize: size, cameraPosition: cameraPosition));
    }
  }
}
