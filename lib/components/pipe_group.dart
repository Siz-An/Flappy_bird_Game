import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import '../Game/flappy_bird_game.dart';
import '../utils/assets.dart';
import '../utils/configuration.dart';
import '../utils/pipe_position.dart';
import 'pipe.dart';

class PipeGroup extends PositionComponent with HasGameRef<FlappyBirdGame> {
  PipeGroup();

  final _random = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position.x = gameRef.size.x;

    final heightMinusGround = gameRef.size.y - Config.groundHeight;
    final spacing = Config.pipeSpacing;

    // Determine a reasonable center position for the pipes
    final centerY = Config.pipeMinHeight +
        _random.nextDouble() * (heightMinusGround - Config.pipeMinHeight * 2 - spacing);

    // Calculate the heights of the pipes
    final topPipeHeight = centerY - spacing / 2;
    final bottomPipeHeight = heightMinusGround - (centerY + spacing / 2);

    // Ensure heights are clamped to avoid negative values
    final adjustedTopPipeHeight = topPipeHeight.clamp(Config.pipeMinHeight, heightMinusGround).toDouble();
    final adjustedBottomPipeHeight = bottomPipeHeight.clamp(Config.pipeMinHeight, heightMinusGround).toDouble();

    // Add pipes to the group
    addAll([
      Pipe(pipePosition: PipePosition.top, height: adjustedTopPipeHeight),
      Pipe(pipePosition: PipePosition.bottom, height: adjustedBottomPipeHeight),
    ]);
  }

  void updateScore() {
    gameRef.bird.score += 1;
    FlameAudio.play(Assets.point);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;

    if (position.x < -50) { // Adjust the condition to ensure pipes are removed correctly
      updateScore();
      removeFromParent();
    }

    if (gameRef.isHit) {
      removeFromParent();
      gameRef.isHit = false;
    }
  }
}
