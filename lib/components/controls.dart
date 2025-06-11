import 'dart:async';

import 'package:bunny_befuddle/components/_components.dart';
import 'package:flame/components.dart';

/// {@template BControls}
///
/// A component that contains the control buttons.
///
/// {@endtemplate}
class BControls extends PositionComponent {
  /// {@macro BControls}
  BControls({
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

  late final BControlButton _leftButton;
  late final BControlButton _rightButton;
  late final BControlButton _forwardButton;
  late final BControlButton _backwardButton;

  late final BControlButton _jumpButton;

  @override
  FutureOr<void> onLoad() {
    _leftButton = BControlButton(
      imageSrc: 'control_left.png',
      onPressed: onLeftPressed,
      onReleased: onDirectionReleased,
    );

    _rightButton = BControlButton(
      imageSrc: 'control_right.png',
      onPressed: onRightPressed,
      onReleased: onDirectionReleased,
    );

    _forwardButton = BControlButton(
      imageSrc: 'control_forward.png',
      onPressed: onForwardPressed,
      onReleased: onDirectionReleased,
    );

    _backwardButton = BControlButton(
      imageSrc: 'control_backward.png',
      onPressed: onBackwardPressed,
      onReleased: onDirectionReleased,
    );

    _jumpButton = BControlButton(
      imageSrc: 'control_jump.png',
      onPressed: onJumpPressed,
      onReleased: onDirectionReleased,
    );

    add(_leftButton);
    add(_rightButton);
    add(_forwardButton);
    add(_backwardButton);
    add(_jumpButton);
  }

  @override
  void onGameResize(Vector2 size) {
    _leftButton.position = Vector2(80, size.y - 120);
    _rightButton.position = Vector2(160, size.y - 120);
    _forwardButton.position = Vector2(120, size.y - 80);
    _backwardButton.position = Vector2(120, size.y - 160);
    _jumpButton.position = Vector2(size.x - 80, size.y - 120);
    super.onGameResize(size);
  }
}
