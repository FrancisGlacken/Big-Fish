import 'dart:ui';

import 'package:big_fish/game.dart';
import 'package:big_fish/screens/title_screen.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

main() {
  final myGame = BigFishGame();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      // Dark more because we are too cool for white theme.
      themeMode: ThemeMode.dark,
      // Use custom theme with 'BungeeInline' font.
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'BungeeInline',
        scaffoldBackgroundColor: Colors.black,
      ),

      home: const TitleScreen(),
    ),
  );
}
