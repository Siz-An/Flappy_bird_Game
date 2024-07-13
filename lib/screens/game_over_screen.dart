// screens/game_over_screen.dart
import 'package:flutter/material.dart';
import '../Game/flappy_bird_game.dart';
import '../utils/storage.dart';

class GameOverScreen extends StatefulWidget {
  final FlappyBirdGame game;

  const GameOverScreen({Key? key, required this.game}) : super(key: key);

  @override
  _GameOverScreenState createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  int highScore = 0;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final storedHighScore = await Storage.getHighScore();
    setState(() {
      highScore = storedHighScore;
    });

    if (widget.game.bird.score > storedHighScore) {
      setState(() {
        highScore = widget.game.bird.score;
      });
      await Storage.saveHighScore(widget.game.bird.score);
    }
  }

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.black38,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Game Over',
            style: TextStyle(
              fontSize: 60,
              color: Colors.red,
              fontFamily: 'Game',
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Score: ${widget.game.bird.score}',
            style: const TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontFamily: 'Game',
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'High Score: $highScore',
            style: const TextStyle(
              fontSize: 40,
              color: Colors.yellow,
              fontFamily: 'Game',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRestart,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text(
              'Restart',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    ),
  );

  void onRestart() {
    widget.game.bird.reset();
    widget.game.overlays.remove('gameOver');
    widget.game.resumeEngine();
  }
}
