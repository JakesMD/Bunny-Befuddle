import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

/// {@template BControlButtonComponent}
///
/// A button with the control image.
///
/// {@endtemplate}
class BControlButtonComponent extends SpriteComponent with TapCallbacks {
  /// {@macro BControlButtonComponent}
  BControlButtonComponent({
    required this.imageSrc,
    required this.onPressed,
    this.onReleased,
  });

  /// The source of the image to use for the button.
  final String imageSrc;

  /// The function to call when the button is pressed.
  final void Function() onPressed;

  /// The function to call when the button is released.
  final void Function()? onReleased;

  /// Whether the button is currently pressed.
  bool get isPressed => _isPressed;

  bool _isPressed = false;

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load(imageSrc);
    scale = Vector2.all(0.75);
    anchor = Anchor.center;
  }

  @override
  void onTapDown(TapDownEvent event) {
    _isPressed = true;
    onPressed();
  }

  @override
  void onTapUp(TapUpEvent event) {
    _isPressed = false;
    onReleased?.call();
  }
}
