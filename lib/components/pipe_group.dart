// components/pipe_group.dart
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

    // Initialize position.x to the right edge of the screen
    position.x = gameRef.size.x;

    final heightMinusGround = gameRef.size.y - Config.groundHeight;
    final spacing = Config.pipeSpacing; // Use the new spacing configuration
    final centerY = Config.pipeMinHeight +
        _random.nextDouble() * (heightMinusGround - Config.pipeMinHeight * 2 - spacing);

    // Ensure centerY is within bounds
    final topPipeHeight = centerY - spacing / 2;
    final bottomPipeHeight = heightMinusGround - (centerY + spacing / 2);

    // Add top and bottom pipes
    addAll([
      Pipe(pipePosition: PipePosition.top, height: topPipeHeight),
      Pipe(pipePosition: PipePosition.bottom, height: bottomPipeHeight),
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

    // Check if the pipe group has moved off-screen
    if (position.x < -10) {
      updateScore();
      removeFromParent();
    }

    // Handle collision detection
    if (gameRef.isHit) {
      removeFromParent();
      gameRef.isHit = false;
    }
  }
}
