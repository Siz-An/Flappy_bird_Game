import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import '../Game/flappy_bird_game.dart';
import '../utils/assets.dart';
import '../utils/bird_movement.dart';
import '../utils/configuration.dart';

class Bird extends SpriteGroupComponent<BirdMovement>
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Bird();

  int score = 0;
  double velocityY = 0.0;  // Velocity variable for bird movement

  @override
  Future<void> onLoad() async {
    final birdMidFlap = await gameRef.loadSprite(Assets.birdMidFlap);
    final birdUpFlap = await gameRef.loadSprite(Assets.birdUpFlap);
    final birdDownFlap = await gameRef.loadSprite(Assets.birdDownFlap);

    size = Vector2(50, 40);
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    current = BirdMovement.middle;
    sprites = {
      BirdMovement.middle: birdMidFlap,
      BirdMovement.up: birdUpFlap,
      BirdMovement.down: birdDownFlap,
    };

    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply gravity
    velocityY += Config.gravity * dt;

    // Update bird's position
    position.y += velocityY * dt;

    // Check if bird hits the top of the screen
    if (position.y < 0) {
      position.y = 0;
      velocityY = 0;
    }

    // Check if bird hits the ground
    if (position.y + size.y > gameRef.size.y - Config.groundHeight) {
      position.y = gameRef.size.y - Config.groundHeight - size.y;
      gameOver();
    }
  }

  void fly() {
    // Apply an upward velocity
    velocityY = -Config.birdFlyVelocity;

    FlameAudio.play(Assets.flying);
    current = BirdMovement.up;

    // Reset to middle after a short delay
    Future.delayed(Duration(milliseconds: 300), () {
      current = BirdMovement.middle;
    });
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints,
      PositionComponent other,
      ) {
    super.onCollisionStart(intersectionPoints, other);
    gameOver();
  }

  void reset() {
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    score = 0;
    velocityY = 0.0;  // Reset velocity
  }

  void gameOver() {
    FlameAudio.play(Assets.collision);
    gameRef.isHit = true;
    gameRef.overlays.add('gameOver');
    gameRef.pauseEngine();
  }
}
