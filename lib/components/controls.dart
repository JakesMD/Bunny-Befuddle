import 'dart:async';
import 'dart:math';

import 'package:bunny_befuddle/components/_components.dart';
import 'package:flame/components.dart';

/// {@template BControlsComponent}
///
/// A component that contains the control buttons.
///
/// {@endtemplate}
class BControlsComponent extends PositionComponent {
  /// {@macro BControlsComponent}
  BControlsComponent({
    required this.onLeftPressed,
    required this.onRightPressed,
    required this.onForwardPressed,
    required this.onBackwardPressed,
    required this.onDirectionReleased,
    required this.onJumpPressed,
  });

  /// The function to call when the left button is pressed.
  final void Function() onLeftPressed;

  /// The function to call when the right button is pressed.
  final void Function() onRightPressed;

  /// The function to call when the forward button is pressed.
  final void Function() onForwardPressed;

  /// The function to call when the backward button is pressed.
  final void Function() onBackwardPressed;

  /// The function to call when the left/right/forward/backward button is
  /// released.
  final void Function() onDirectionReleased;

  /// The function to call when the jump button is pressed.
  final void Function() onJumpPressed;

  late final PositionComponent _directionButtons;
  late final BControlButtonComponent _jumpButton;

  @override
  FutureOr<void> onLoad() {
    final leftButton = BControlButtonComponent(
      imageSrc: 'control_left.png',
      onPressed: onLeftPressed,
      onReleased: onDirectionReleased,
      position: Vector2(-40, 0),
    );

    final rightButton = BControlButtonComponent(
      imageSrc: 'control_right.png',
      onPressed: onRightPressed,
      onReleased: onDirectionReleased,
      position: Vector2(40, 0),
    );

    final forwardButton = BControlButtonComponent(
      imageSrc: 'control_forward.png',
      onPressed: onForwardPressed,
      onReleased: onDirectionReleased,
      position: Vector2(0, 40),
    );

    final backwardButton = BControlButtonComponent(
      imageSrc: 'control_backward.png',
      onPressed: onBackwardPressed,
      onReleased: onDirectionReleased,
      position: Vector2(0, -40),
    );

    _directionButtons = PositionComponent(
      children: [leftButton, rightButton, forwardButton, backwardButton],
      angle: 0.25 * pi,
      anchor: Anchor.center,
    );

    _jumpButton = BControlButtonComponent(
      imageSrc: 'control_jump.png',
      onPressed: onJumpPressed,
    );

    add(_directionButtons);
    add(_jumpButton);
  }

  @override
  void onGameResize(Vector2 size) {
    _directionButtons.position = Vector2(80, size.y - 120);
    _jumpButton.position = Vector2(size.x - 60, size.y - 120);
    super.onGameResize(size);
  }
}
