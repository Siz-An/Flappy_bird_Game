import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import '../Game/flappy_bird_game.dart';
import '../utils/assets.dart';
import '../utils/configuration.dart';
import '../utils/pipe_position.dart';

class Pipe extends PositionComponent with HasGameRef<FlappyBirdGame> {
  Pipe({
    required this.pipePosition,
    required this.height,
  });

  @override
  final double height;
  final PipePosition pipePosition;

  late SpriteComponent pipeSprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the image
    final pipeImage = await Flame.images.load(Assets.pipe);
    final pipeRotatedImage = await Flame.images.load(Assets.pipeRotated);

    // Initialize the sprite component
    pipeSprite = SpriteComponent(
      sprite: Sprite(pipePosition == PipePosition.top ? pipeRotatedImage : pipeImage),
      size: Vector2(50, height), // Ensure the pipe size is set correctly
    );

    // Set the position of the pipe
    switch (pipePosition) {
      case PipePosition.top:
        position = Vector2(0, 0); // Top pipes start from the top
        break;
      case PipePosition.bottom:
        position = Vector2(0, gameRef.size.y - height - Config.groundHeight); // Bottom pipes start from below the top pipe
        break;
    }

    add(pipeSprite);
    add(RectangleHitbox(size: Vector2(50, height))); // Hitbox should match the pipe's size
  }
}
