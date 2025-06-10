/// {@template BBlockProximity}
///
/// Represents the proximity of blocks to a position.
///
/// {@endtemplate}
class BBlockProximity {
  /// {@macro BBlockProximity}
  const BBlockProximity({
    required this.isBlockWithin,
    required this.isBlockBelow,
  });

  /// Whether the block is in the position.
  final bool isBlockWithin;

  /// Whether the block is below the position.
  final bool isBlockBelow;
}
