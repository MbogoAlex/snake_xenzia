import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake/blank_pixel.dart';
import 'package:snake/food_pixel.dart';
import 'package:snake/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int rowSize = 10;
  int totalNumberOfSquares = 100;
  List<int> snakePos = [0, 1, 2];
  int foodPos = 55;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                print("Tapped");
                if (details.delta.dy > 0) {
                  print("move down");
                } else if (details.delta.dy < 0) {
                  print("Move up");
                }
              },
              onHorizontalDragUpdate: (details) {
                print("Tapped");
                if (details.delta.dx > 0) {
                  print("move right");
                } else if (details.delta.dx < 0) {
                  print("Move left");
                }
              },
              child: GridView.builder(
                itemCount: totalNumberOfSquares,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowSize,
                ),
                itemBuilder: (context, index) {
                  if (snakePos.contains(index)) {
                    return const SnakePixel();
                  } else if (foodPos == index) {
                    return const FoodPixel();
                  } else {
                    return const BlankPixel();
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: MaterialButton(
                  onPressed: startGame,
                  child: Text("PLAY"),
                  color: Colors.pink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void startGame() {
    print("STARTED");
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        int newHead = snakePos.last + 1;

        if (newHead == foodPos) {
          snakePos.add(newHead);
          foodPos = _generateRandomFoodPosition();
        } else {
          snakePos.add(newHead);
          snakePos.removeAt(0);
        }

        print("Snake position: ${snakePos}");

        // You can add additional logic here to check for collisions with the walls or itself
      });
    });
  }

  int _generateRandomFoodPosition() {
    return Random().nextInt(totalNumberOfSquares);
  }
}
