import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import '../Game/flappy_bird_game.dart';
import '../utils/assets.dart';
import '../utils/configuration.dart';
import '../utils/pipe_position.dart';
import 'pipe.dart';

class PipeGroup extends PositionComponent with HasGameRef<FlappyBirdGame> {
  PipeGroup({this.isFirstPipe = false});

  final _random = Random();
  final bool isFirstPipe;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position.x = gameRef.size.x;

    final heightMinusGround = gameRef.size.y - Config.groundHeight;

    // Get current spacing based on the player's score
    final spacing = getCurrentPipeSpacing(gameRef.bird.score);

    // Determine a reasonable center position for the pipes
    final centerY = isFirstPipe
        ? heightMinusGround * 0.3 // Lower center position for the first pipe
        : Config.pipeMinHeight +
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

  double getCurrentPipeSpacing(int score) {
    // Decrease spacing as score increases
    final minSpacing = 80.0;
    final maxSpacing = 200.0;
    final spacingReductionFactor = 0.5;
    return (maxSpacing - (score * spacingReductionFactor)).clamp(minSpacing, maxSpacing);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Increase game speed as score increases
    final speedIncreaseFactor = 0.5;
    position.x -= (Config.gameSpeed + gameRef.bird.score * speedIncreaseFactor) * dt;

    if (position.x < -50) {
      updateScore();
      removeFromParent();
    }

    if (gameRef.isHit) {
      removeFromParent();
      gameRef.isHit = false;
    }
  }
}
