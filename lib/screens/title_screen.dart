import 'package:big_fish/screens/game_screen.dart';
import 'package:flutter/material.dart';

// Represents the main menu screen of Spacescape, allowing
// players to start the game or modify in-game settings.
class TitleScreen extends StatelessWidget {
  const TitleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Game title.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Text(
                'Lil Big Fish',
                style: TextStyle(
                  fontSize: 50.0,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      blurRadius: 20.0,
                      color: Colors.white,
                      offset: Offset(0, 0),
                    )
                  ],
                ),
              ),
            ),

            // Play button.
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  // Push and replace current screen (i.e MainMenu) with
                  // SelectSpaceship(), so that player can select a spaceship.
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const GameScreen(),
                    ),
                  );
                },
                child: Text('Play'),
              ),
            ),

            // Options button.
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to options screen.
                },
                child: Text('Options'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
