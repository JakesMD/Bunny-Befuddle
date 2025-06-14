import 'package:bunny_befuddle/config.dart';
import 'package:bunny_befuddle/extensions/_extensions.dart';
import 'package:bunny_befuddle/worlds/_worlds.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';

/// The player component.
///
/// This component handles the player's movement and animation by listening to
/// keyboard inputs.
class BBunnyComponent extends PositionComponent
    with KeyboardHandler, HasWorldReference<BLevelWorld> {
  /// The position of the bunny in 3D space.
  Vector3 get position3D => _position3D;

  late Vector3 _position3D;
  Vector3 _velocity = Vector3.zero();
  bool _isFalling = false;

  late SpriteAnimationComponent _walkComponent;
  late SpriteAnimationComponent _idleComponent;
  late SpriteComponent _jumpComponent;

  @override
  Future<void> onLoad() async {
    await Flame.images.loadAll([
      'bunny_2_jump.png',
      'bunny_2_ready.png',
      'bunny_2_stand.png',
      'bunny_2_walk1.png',
      'bunny_2_walk2.png',
    ]);

    _position3D = Vector3.copy(world.level.startPosition);
    _updatePositionAndPriority();

    final walkAnimation = SpriteAnimation.spriteList([
      Sprite(Flame.images.fromCache('bunny_2_walk1.png')),
      Sprite(Flame.images.fromCache('bunny_2_walk2.png')),
    ], stepTime: 0.12);

    _walkComponent = SpriteAnimationComponent(
      animation: walkAnimation,
      scale: Vector2.all(0.3),
      anchor: Anchor.bottomCenter,
      position: Vector2.zero(),
    );

    final idleAnimation = SpriteAnimation.spriteList([
      Sprite(Flame.images.fromCache('bunny_2_ready.png')),
      Sprite(Flame.images.fromCache('bunny_2_stand.png')),
    ], stepTime: 0.3);

    _idleComponent = SpriteAnimationComponent(
      animation: idleAnimation,
      scale: Vector2.all(0.3),
      anchor: Anchor.bottomCenter,
      position: Vector2.zero(),
    );

    _jumpComponent = SpriteComponent(
      sprite: Sprite(Flame.images.fromCache('bunny_2_jump.png')),
      scale: Vector2.all(0.3),
      anchor: Anchor.bottomCenter,
      position: Vector2.zero(),
    );

    add(_idleComponent);
  }

  /// Makes the bunny jump if not already in the air.
  void jump() {
    if (!_isFalling) _velocity.z = bPlayerJumpVelocity;
  }

  /// Moves the bunny in the negative x direction.
  void moveLeft() {
    if (!isFlippedHorizontally) flipHorizontally();
    _velocity.y = 0;
    _velocity.x = -bPlayerWalkVelocity;
  }

  /// Moves the bunny in the positive x direction.
  void moveRight() {
    if (isFlippedHorizontally) flipHorizontally();
    _velocity.y = 0;
    _velocity.x = bPlayerWalkVelocity;
  }

  /// Moves the bunny in the negative y direction.
  void moveBackward() {
    if (isFlippedHorizontally) flipHorizontally();
    _velocity.x = 0;
    _velocity.y = -bPlayerWalkVelocity;
  }

  /// Moves the bunny in the positive y direction.
  void moveForward() {
    if (!isFlippedHorizontally) flipHorizontally();
    _velocity.x = 0;
    _velocity.y = bPlayerWalkVelocity;
  }

  /// Stops the bunny from moving.
  void standStill() {
    _velocity.x = 0;
    _velocity.y = 0;
  }

  /// Resets the bunny to its initial position and velocity.
  void reset() {
    _position3D = Vector3.copy(world.level.startPosition);
    _velocity = Vector3.zero();
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _velocity = Vector3(0, 0, _velocity.z);

    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      moveBackward();
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      moveForward();
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      moveLeft();
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      moveRight();
    } else {
      standStill();
    }

    if (keysPressed.contains(LogicalKeyboardKey.space)) jump();

    return true;
  }

  @override
  void update(double dt) {
    if (_position3D.z < bNegativeZLimit) world.reset();
    _updateZVelocity(dt);
    _updateXYPosition(dt);
    _updateZPosition(dt);
    _updateCostume();
    _updatePositionAndPriority();
  }

  void _updateZVelocity(double dt) =>
      _velocity.z -= bGravitationalAcceleration * dt;

  void _updateXYPosition(double dt) {
    final newPos = _position3D + Vector3(_velocity.x * dt, _velocity.y * dt, 0);

    if (world.level.fetchBlock(newPos) == null) {
      _position3D.x = newPos.x;
      _position3D.y = newPos.y;
    }
  }

  void _updateZPosition(double dt) {
    var velocityZ = _velocity.z * dt;
    if (velocityZ * dt < -bBlockSize.y * 0.5 / bPlayerWalkVelocity) {
      velocityZ = -bBlockSize.y * 0.5 / bPlayerWalkVelocity;
    }

    final newPos = _position3D + Vector3(0, 0, velocityZ);

    if (world.level.fetchBlock(newPos) == null) {
      _position3D.z = newPos.z;
      _isFalling = true;
    } else {
      if (_velocity.z < 0) _position3D.z = _position3D.z.floorToDouble();
      _velocity.z = 0;
      _isFalling = false;
    }
  }

  void _updateCostume() {
    if (_isFalling) {
      if (_idleComponent.parent != null) remove(_idleComponent);
      if (_walkComponent.parent != null) remove(_walkComponent);
      if (_jumpComponent.parent == null) add(_jumpComponent);
    } else if (_velocity.x != 0 || _velocity.y != 0) {
      if (_jumpComponent.parent != null) remove(_jumpComponent);
      if (_idleComponent.parent != null) remove(_idleComponent);
      if (_walkComponent.parent == null) add(_walkComponent);
    } else if (_velocity.x == 0 && _velocity.y == 0 && !_isFalling) {
      if (_jumpComponent.parent != null) remove(_jumpComponent);
      if (_walkComponent.parent != null) remove(_walkComponent);
      if (_idleComponent.parent == null) add(_idleComponent);
    }
  }

  void _updatePositionAndPriority() {
    position = _position3D.toIsometricPosition;
    priority = _position3D.isometricPriority;
  }
}
