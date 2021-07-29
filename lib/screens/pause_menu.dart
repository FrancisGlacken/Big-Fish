import 'package:big_fish/components/pause_button.dart';
import 'package:big_fish/game.dart';
import 'package:big_fish/screens/game_screen.dart';
import 'package:big_fish/screens/title_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PauseMenu extends StatelessWidget {
  static const String ID = "PauseMenu";
  final BigFishGame gameRef;
  const PauseMenu({Key? key, required this.gameRef}) : super(key: key);

  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        // Game title.
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: Text(
              'Paused',
              style: TextStyle(fontSize: 50.0, color: Colors.white, shadows: [
                Shadow(
                    blurRadius: 15.0, color: Colors.green, offset: Offset(0, 0))
              ]),
            )),

        // Resume button.
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: ElevatedButton(
            onPressed: () {
              gameRef.resumeEngine();
              gameRef.overlays.remove(PauseMenu.ID);
              gameRef.overlays.add(PauseButton.ID);
            },
            child: Text('Resume'),
          ),
        ),

        //TODO: Add Restart Button?

        // Exit button.
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: ElevatedButton(
            onPressed: () {
              gameRef.overlays.remove(PauseMenu.ID);
              //gameRef.reset();

              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const TitleScreen(),
              ));
            },
            child: Text('Exit'),
          ),
        ),
      ],
    ));
  }
}
