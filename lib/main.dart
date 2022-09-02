import 'package:flutter/material.dart';
import 'package:space_snake/space_game/space.dart';

void main() {
  runApp(const SpaceSnake());
}

class SpaceSnake extends StatelessWidget {
  const SpaceSnake({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        backgroundColor: Colors.black,
          body: Space()),
    );
  }
}

