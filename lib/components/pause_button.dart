import 'package:big_fish/game.dart';
import 'package:big_fish/screens/pause_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PauseButton extends StatelessWidget {
  static const String ID = 'PauseButton';
  final BigFishGame gameRef;
  const PauseButton({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: TextButton(
          child: Icon(Icons.pause_rounded, color: Colors.white),
          onPressed: () {
            gameRef.pauseEngine();
            gameRef.overlays.add(PauseMenu.ID);
            gameRef.overlays.add(PauseMenu.ID);
          }),
    );
  }
}
