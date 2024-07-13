
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:flappy_bird/Game/flappy_bird_game.dart';
import 'package:flappy_bird/utils/configuration.dart';

import '../utils/imageString.dart';

class Ground extends ParallaxComponent<FlappyBirdGame>{

  @override
  Future<void> onLoad() async{
  final ground = await Flame.images.load(Assets.ground);
    parallax = Parallax([
      ParallaxLayer(
      ParallaxImage(ground, fill: LayerFill.none)),
    ]);
  }
  @override
  void update(double dt){
    super.update(dt);
    parallax?.baseVelocity.x = Config.gameSpeed;
  }
}