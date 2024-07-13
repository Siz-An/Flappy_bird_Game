import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import '../Game/flappy_bird_game.dart';
import '../utils/assets.dart';

class Background extends SpriteComponent with HasGameRef<FlappyBirdGame> {
  Background();

  @override
  Future<void> onLoad() async {
    final background = await Flame.images.load(Assets.background);
    size = gameRef.size;
    sprite = Sprite(background);
  }
}
