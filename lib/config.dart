import 'package:flame/components.dart';

/// The size of a tile image in pixels.
final bBlockSize = Vector2(111, 64);

/// The speed of a cloud infinitely close to the camera in pixels per tick.
const bCloudVelocity = 50.0;

/// The speed the player walks in pixels per tick.
const bPlayerWalkVelocity = 2.0;

/// The speed the player jumps in pixels per tick.
///
/// Note: The player should not be able to jump up 3 stories and along 3 blocks,
///       because otherwise the player could skip levels.
const bPlayerJumpVelocity = 25.0;

/// The number of clouds in the sky at any given time.
///
/// Note: Not all the clouds will be within the camera's viewport.
const bNumberOfClouds = 50;

/// The amount the player falls faster per tick.
const bGravitationalAcceleration = 50;

/// The maximum number of blocks below story 0 the player can fall before dying.
const bNegativeZLimit = -20;
